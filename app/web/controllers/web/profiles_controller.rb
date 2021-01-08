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
