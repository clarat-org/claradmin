# frozen_string_literal: true
require ClaratBase::Engine.root.join('app', 'models', 'split_base')

class SplitBase < ActiveRecord::Base
  # Methods
  # delegate :name, to: :organizations, prefix: true, allow_nil: true
  delegate :name, to: :solution_category, prefix: true, allow_nil: true

  def display_name
    "##{id} #{organizations.pluck(:name).join(', ')} || #{title} || "\
      "#{solution_category_name} || #{clarat_addition}"
  end

  include PgSearch
  pg_search_scope :search_pg,
                  against: [:title, :clarat_addition, :comments,
                            :solution_category_id],
                  using: { tsearch: { prefix: true } }
end
