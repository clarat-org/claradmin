# frozen_string_literal: true
# rubocop:disable Metrics/ModuleLength
module GenericSortFilter
  def self.transform(base_query, params)
    query = ensure_query(base_query)
    query = transform_by_searching(query, params[:query])
    query = transform_by_joining(query, params)
    query = transform_by_ordering(query, params)
    transform_by_filtering(query, params)
  end

  private_class_method

  # In case only a model was passed in, to unify object handling, turn it into
  # a query
  def self.ensure_query(query)
    query.where('1 = 1')
  end

  def self.transform_by_searching(query, param)
    if !param || param.empty? || query.search_everything(param).nil?
      query
    else
      query.search_everything(param).with_pg_search_rank
    end
  end

  def self.transform_by_joining(query, params)
    if params[:sort_model]
      query = query.eager_load(params[:sort_model].split('.').first)
    end

    params[:filters]&.each do |filter, _value|
      next unless filter['.']
      association_name = filter.split('.').first
      next if referring_to_own_table?(query, association_name) # dont join self
      query = query.eager_load(association_name.to_sym)
    end

    query
  end

  def self.transform_by_ordering(query, params)
    return query unless params[:sort_field]
    sort_string = params[:sort_field]
    if params[:sort_model]
      association_name = table_name_for(query, params[:sort_model])
      sort_string = "#{association_name}.#{sort_string}"
    end
    sort_string += ' ' + (params[:sort_direction] || 'DESC')
    query.order(sort_string)
  end

  def self.transform_by_filtering(query, params)
    return query unless params[:filters]
    params[:filters].each do |filter, value|
      next if value.empty?
      # convert value to array for streamlined processing
      singular_or_multiple_values = value.is_a?(Array) ? value : [value]
      # build query strings for every array entry (only one for simple filters)
      if range_filter_query?(params, singular_or_multiple_values)
        query = build_range_filter_query(query, params, filter, value)
      else
        filtered_strings = filter_strings(singular_or_multiple_values, query, params, filter)
        query = query.where(filtered_strings.join(join_operator(params, filter)))
      end
    end
    query
  end

  def self.filter_strings(values, query, params, filter)
    values.reject(&:blank?).map do |value|
      build_singular_filter_query(query, params, filter, value)
    end
  end

  def self.range_filter_query?(params, values)
    !params[:operators].nil? && params[:operators].value?('...') && values.reject(&:blank?).count > 1
  end

  def self.join_operator(params, filter)
    if !params[:operators] || !params[:operators][filter] ||
       params[:operators][filter] == '='
      ' OR '
    else
      ' AND '
    end
  end

  def self.build_range_filter_query(query, params, filter, value)
    range = value.sort
    filter_key = joined_or_own_table_name_for(query, filter, params)
    filter_string = filter_key.to_s
    query.where("#{filter_string} BETWEEN '#{range[0]}' and '#{range[1]}'")
  end

  def self.build_singular_filter_query(query, params, filter, value)
    # transform table names (before a .) in case of association name mismatch
    filter_key = joined_or_own_table_name_for(query, filter, params)
    filter_string = filter_key.to_s
    # append operator
    operator = process_operator(params[:operators], filter, value)
    filter_string += ' ' + operator
    # append value
    new_value = transform_value(value, filter, query)
    filter_string += ' ' + new_value
    # append optional addition
    filter_string + optional_query_addition(operator, new_value, filter_key)
  end

  def self.joined_or_own_table_name_for(query, filter, params)
    if filter['.']
      split_filter = filter.split('.')
      split_filter[0] = table_name_for(query, split_filter[0])
      split_filter.join('.')
    elsif params[:controller]
      params[:controller].split('/').last + '.' + filter
    else
      filter
    end
  end

  def self.table_name_for(query, filter)
    return filter if referring_to_own_table?(query, filter)
    association_for(query, filter).table_name
  end

  def self.association_for(query, filter)
    query.model.reflections[filter]
  end

  # retrives the given operator or falls back to '='. Special case for 'nil'
  def self.process_operator(operators, filter, value)
    operator = operators && operators[filter] && operators[filter] != '...' ? operators[filter] : '='
    if nullable_value?(value)
      operator = operator == '=' ? 'IS' : 'IS NOT'
    end
    operator
  end

  def self.transform_value(value, filter, query)
    model_name =
      if filter.include?('.')
        filter.split('.').first.classify.constantize
      else
        query.model
      end
    value = parse_value_by_type(value, filter, model_name)
    # NULL-filters are not allowed to stand within ''
    nullable_value?(value) ? 'NULL' : "'#{value}'"
  end

  def self.parse_value_by_type(value, filter, model_name)
    # convert datetime strings to specific format for query
    if model_name.columns_hash[filter] && !nullable_value?(value) &&
       model_name.columns_hash[filter].type == :datetime && !value.empty?
      DateTime.parse(value + ' CET').utc.to_s
    else
      value
    end
  end

  def self.optional_query_addition(operator, value, filter_key)
    # append OR NULL for non-null, NOT-queries (include optionals)
    if operator == '!=' && !nullable_value?(value)
      " OR #{filter_key} IS NULL"
    else
      ''
    end
  end

  def self.nullable_value?(value)
    value == 'nil' || value == 'null' || value == 'NULL'
  end

  def self.referring_to_own_table?(query, string)
    string.classify == query.model.name
  end
end
# rubocop:enable Metrics/ModuleLength
