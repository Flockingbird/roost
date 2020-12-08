# frozen_string_literal: true

module ViewModels
  ##
  # A Member Profile view model
  class Profile < OpenStruct
    def self.from_collection(collection)
      collection.map { |attrs| new(attrs) }
    end

    def handle
      Handle.new(username)
    end

    def updated_on
      updated_at&.to_date
    end
  end
end
