class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create, :index, :show]
  before_action :get_user, only: [:show]

  def index
    @users = User.all
    render json: @users
  end

  def profile
    render json: { user: UserSerializer.new(current_user) }, status: :accepted
  end

  def show
    render json: {user: UserSerializer.new(@user), liked_posts: @user.likes.sort {|a,b| b.created_at <=> a.created_at }.map{|l| PostSerializer.new(l.post)}}
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.tag_ids = params[:tag_ids]
      @user.save

      @token = encode_token({ user_id: @user.id })
      render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
    else
      render json: { error: @user.errors.full_messages, status: :not_acceptable }
    end
  end

  def update
    if @user.valid?
      @user.update(user_params)
      @user.tag_ids = params[:tag_ids]
      @user.save
      render json: @user
    end
  end

  def destroy
    user = @user
    @user.destroy
    render json: user
  end

  private
  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:id, :name, :birth_date, :email, :username, :town, :avatar, :bio, :password, :password_confirmation, tag_ids: [])
  end

end
