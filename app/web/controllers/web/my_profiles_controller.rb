# frozen_string_literal: true

module Web
  ##
  # Handles my profile views: member interacts with own profile
  class MyProfilesController < WebController
    get '/profile' do
      requires_authorization
      profile = ViewModels::Profile.new(current_member)
      erb :profile, layout: :layout_member, locals: { profile: profile }
    end

    put '/profile' do
      requires_authorization
      Commands.handle('Profile', 'Update',
                      put_params.merge(aggregate_id: member_id))
      redirect '/profile'
    end

    get '/profile/edit' do
      requires_authorization
      profile = ViewModels::Profile.new(current_member)
      erb(:profile_edit, layout: :layout_member, locals: { profile: profile })
    end

    private

    def put_params
      params.slice('bio', 'name')
    end

    def may_add_contact?
      false # We may never add ourselves.
    end
  end
end
