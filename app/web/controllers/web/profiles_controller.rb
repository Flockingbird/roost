# frozen_string_literal: true

module Web
  ##
  # Handles profile views
  class ProfilesController < WebController
    # TODO: /@handle should redirect to /@handle@example.org when we are
    # on example.org
    # TODO: /handle should redirect to /@handle@example.org as well
    get '/@:handle' do
      member = Projections::Members::Query.find_by(
        username: Handle.parse(params[:handle]).username
      )
      raise NotFound, 'Member with that handle not found' unless member

      profile = ViewModels::Profile.new(member)
      erb(:profile, layout: :layout_member, locals: { profile: profile })
    end
  end
end
