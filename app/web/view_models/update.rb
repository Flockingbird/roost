# frozen_string_literal: true

module ViewModels
  ##
  # A status Update view model
  class Update < OpenStruct
    def self.from_collection(collection)
      collection.map { |attrs| new(attrs) }
    end

    def posted_on
      posted_at.to_date
    end

    def posted_at
      super || NullDateTime.new('never')
    end
  end
end
