# frozen_string_literal: true

module Web
  ##
  # Handles profile views
  class ProfilesController < WebController
    include PolicyHelpers
    include LoadHelpers

    # TODO: /@handle should redirect to /@handle@example.org when we are
    # on example.org
    # TODO: /handle should redirect to /@handle@example.org as well
    # TODO: redirect to remote host if handle is note remote. E.g.
    # if we are on example.com and get a @handle@example.org we should redirect
    # to example.org/m/handle@example.org. But for that we need remote
    # canonical location determination (e.g. webfinger) first.
    get '/m/:handle' do
      raise NotFound, 'Member with that handle not found' if profile.null?

      erb(:profile, layout: :layout_member, locals: { profile: profile })
    end

    private

    def profile
      @profile ||= decorate(
        load(
          Aggregates::Member,
          Projections::Members::Query.aggregate_id_for(params[:handle])
        ),
        ViewModels::Profile,
        ViewModels::Profile::NullProfile
      )
    end
    alias contact profile
  end
end
