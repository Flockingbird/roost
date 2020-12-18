# frozen_string_literal: true

module Web
  ##
  # Handles profile views
  class ProfilesController < WebController
    include PolicyHelpers

    # TODO: /@handle should redirect to /@handle@example.org when we are
    # on example.org
    # TODO: /handle should redirect to /@handle@example.org as well
    get '/@:handle' do
      raise NotFound, 'Member with that handle not found' if profile.null?

      erb(:profile, layout: :layout_member, locals: { profile: profile })
    end

    private

    def profile
      return @profile if @profile

      member = Projections::Members::Query.find_by(
        username: Handle.parse(params[:handle]).username
      )
      @profile = ViewModels::Profile.new(member)
    end
    alias contact profile
  end
end
