class UsersController < ApplicationController
  [Company, Degree, Field, Gender, School, Standing] if Rails.env == 'development'
  def index
    # Randomness
    params[:seed] ||= Random.new_seed
    srand params[:seed].to_i

    # Users
		users = User.all
    @users = Kaminari.paginate_array(users.shuffle).page(params[:page]).per(12)
  end

  def show
		@user = User.find(params[:id])
  end

  def users
    # Randomness
    params[:seed] ||= Random.new_seed
    srand params[:seed].to_i

    # Users
    users = User.joins(:communities).where(communities: { id: current_user.community_ids })
    users = users.where(communities: { id: params[:f] }).select("users.*, count(distinct(communities.id))").group("users.id").having("count(distinct(communities.id)) = (?)", params[:f].length) if params[:f]
    @users = Kaminari.paginate_array(users.shuffle).page(params[:page]).per(12)

    # Filters
    communities = Community.joins(:users).where(users: { id: @users.map(&:id) }).uniq.order(:name)
    @subclass_names = Community.subclasses.map(&:name)
    @subclass_names.each do |name|
      instance_variable_set("@#{name}_filters", communities.where(type: name))
    end
  end
end
