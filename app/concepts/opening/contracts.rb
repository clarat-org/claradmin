# frozen_string_literal: true
module Opening::Contracts
  class Create < Reform::Form

    property :day
    property :open
    property :close
    property :sort_value
    property :name

    validates :day, presence: true
    validate :unique_day_open_close
    validates :open, presence: true, if: :close
    validates :close, presence: true, if: :open

    validates :sort_value, presence: true
    validates :name, presence: true

    def unique_day_open_close
      if Opening.where(day: day, open: open, close: close).count > 0
        errors.add :day, I18n.t('errors.messages.taken')
        errors.add :open, I18n.t('errors.messages.taken')
        errors.add :close, I18n.t('errors.messages.taken')
      end
    end
  end
end
