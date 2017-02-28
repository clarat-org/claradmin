# frozen_string_literal: true
require_relative '../test_helper'
# rubocop:disable Metrics/ClassLength
class GenericSortFilterTest < ActiveSupport::TestCase
  subject { GenericSortFilter }
  let(:query) { Offer.where('1 = 1') }
  let(:invalid_query) { OpenStruct.new }

  describe '#transform_by_searching' do
    it 'does nothing without a param' do
      invalid_query.expects(:search_everything).never
      result = subject.send(:transform_by_searching, invalid_query, nil)
      result.must_equal invalid_query
    end

    it 'does nothing with an empty param' do
      invalid_query.expects(:search_everything).never
      result = subject.send(:transform_by_searching, invalid_query, '')
      result.must_equal invalid_query
    end

    it 'searches with a filled param' do
      query.expects(:search_everything).with('foo').once
      subject.send(:transform_by_searching, query, 'foo')
    end
  end

  describe '#transform_by_joining' do
    it 'eager_loads with a sort_model' do
      params = { sort_model: 'contact_people.fooooo' }
      query.expects(:eager_load).with('contact_people')
      subject.send(:transform_by_joining, query, params)
    end

    it 'eager_loads with a filter' do
      params = { filter: { 'split_base.foo' => 'a', 'logic_version.bar' => 'b' } }
      query.expects(:eager_load).with(:split_base).returns(query)
      query.expects(:eager_load).with(:logic_version).returns(query)
      result = subject.send(:transform_by_joining, query, params)
      result.must_equal query
    end

    it 'wont eager_load without a sort_model or filter' do
      invalid_query.expects(:eager_load).never
      result = subject.send(:transform_by_joining, invalid_query, {})
      result.must_equal invalid_query
    end

    it 'wont eager_load with a filter that references itself' do
      params = { filter: ['offer.baz'] }
      query.expects(:eager_load).never
      subject.send(:transform_by_joining, query, params)
    end

    it 'wont eager_load with a filter that uses no submodel' do
      params = { filter: ['fuz'] }
      query.expects(:eager_load).never
      subject.send(:transform_by_joining, query, params)
    end
  end

  describe '#transform_by_ordering' do
    it 'wont transform without a sort_field' do
      invalid_query.expects(:order).never
      result = subject.send(:transform_by_ordering, invalid_query, {})
      result.must_equal invalid_query
    end

    it 'will order with a sort_field but without sort_model' do
      params = { sort_field: 'foo' }
      query.expects(:order).with('foo DESC')
      subject.send(:transform_by_ordering, query, params)
    end

    it 'will order respecting sort_field, sort_model, and sort_direction' do
      params =
        { sort_field: 'bar', sort_model: 'split_base', sort_direction: 'ASC' }
      query.expects(:order).with('split_bases.bar ASC')
      subject.send(:transform_by_ordering, query, params)
    end
  end

  describe '#transform_by_filtering' do
    it 'wont transform without filters' do
      params = { filters: nil }
      invalid_query.expects(:where).never
      result = subject.send(:transform_by_filtering, invalid_query, params)
      result.must_equal invalid_query
    end

    it 'wont transform with an empty filter set' do
      params = { filters: {} }
      invalid_query.expects(:where).never
      result = subject.send(:transform_by_filtering, invalid_query, params)
      result.must_equal invalid_query
    end

    it 'wont transform with an empty filter value' do
      params = { filters: { foo: '' } }
      invalid_query.expects(:where).never
      result = subject.send(:transform_by_filtering, invalid_query, params)
      result.must_equal invalid_query
    end

    it 'filters for an owned field' do
      params = { filters: { 'foo' => 'bar' } }
      query.expects(:where).with("foo = 'bar'")
      subject.send(:transform_by_filtering, query, params)
    end

    it 'filters with a mismatching association/table name' do
      params = { filters: { 'section_filters.foobar' => 'bazfuz' } }
      query.expects(:where).with("filters.foobar = 'bazfuz'")
      subject.send(:transform_by_filtering, query, params)
    end

    it 'filters with a nullable value' do
      params = { filters: { 'split_base.baz' => 'nil' } }
      query.expects(:where).with('split_bases.baz IS NULL')
      subject.send(:transform_by_filtering, query, params)
    end

    it 'filters with a nullable value and NOT operator value' do
      params = { filters: { 'fuz' => 'NULL' }, operators: { 'fuz' => '!=' } }
      query.expects(:where).with('fuz IS NOT NULL')
      subject.send(:transform_by_filtering, query, params)
    end

    it 'includes NULL values for a "!=" string search' do
      params = { filters: { 'title' => 'smth' }, operators: { 'title' => '!=' } }
      query.expects(:where).with("title != 'smth' OR title IS NULL")
      subject.send(:transform_by_filtering, query, params)
    end

    it 'parses date-times and converts them from CET to UTC' do
      params = { filters: { 'created_at' => '15.09.2014, 13:02:00+0200' } }
      query.expects(:where).with("created_at = '2014-09-15T11:02:00+00:00'")
      subject.send(:transform_by_filtering, query, params)
    end
  end
end
# rubocop:enable Metrics/ClassLength