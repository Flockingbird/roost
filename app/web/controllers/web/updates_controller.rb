# frozen_string_literal: true

module Web
  ##
  # Handles my my updates view, notifications
  class UpdatesController < WebController
    get '/updates' do
      requires_authorization
      updates = ViewModels::Update.from_collection(
        Projections::Updates::Query.for_member(member_id)
      )
      erb :updates, layout: :layout_member, locals: { updates: updates }
    end
  end
end
