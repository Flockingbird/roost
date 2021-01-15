# frozen_string_literal: true

module Web
  ##
  # Handles viewing of tags-edit page and adding new tags to a member
  class TagsController < WebController
    include LoadHelpers

    # TODO: DRY with ProfilesController
    get '/m/:handle/tags' do
      raise NotFound, 'Member with that handle not found' if profile.null?

      erb(:profile_tags, layout: :layout_member, locals: { profile: profile })
    end

    post '/tags' do
      requires_authorization

      Commands.handle(
        'Profile',
        'Tag',
        post_params.merge(
          aggregate_id: profile.id,
          author_id: member_id
        )
      )

      # TODO: raise if no profile handle given
      flash[:success] = "#{profile.handle} was tagged as "\
                        "\"#{post_params['tag']}\""
      redirect "/m/#{profile.handle}"
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

    def post_params
      params.slice('tag')
    end
  end
end
