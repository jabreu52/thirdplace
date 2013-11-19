class CommunitiesController < ApplicationController
  [Company, Degree, Field, Gender, School, Standing] if Rails.env == 'development'
  before_action :set_community, only: [:show, :users]

  def index
    @communities = Community.all
  end

  def show
  end

  def users
    # Randomness
    params[:seed] ||= Random.new_seed
    srand params[:seed].to_i

    # Users
    users = @community.users
    users = users.joins(:communities).where(communities: { id: params[:f] }).select("users.*, count(distinct(communities.id))").group("users.id").having("count(distinct(communities.id)) = (?)", params[:f].length) if params[:f]
    @users = Kaminari.paginate_array(users.shuffle).page(params[:page]).per(12)

    # Filters
    communities = Community.joins(:users).where(users: { id: @users.map(&:id) }).uniq.order(:name)
    @subclass_names = Community.subclasses.map(&:name)
    @subclass_names.each do |name|
      instance_variable_set("@#{name}_filters", communities.where(type: name).where.not(id: @community))
    end
  end

  private
    def set_community
      @community = Community.find(params[:id])
    end
end