# frozen_string_literal: true
module API::V1
  module UserTeam
    module Representer
      class Show < API::V1::Default::Representer::Show
        type :user_teams

        property :name
        property :user_names, getter: ->(ot) do
          ot[:represented].users.pluck(:name).join(', ')
        end
      end

      class Index < Show
        # items extend: Show
      end
    end
  end
end
