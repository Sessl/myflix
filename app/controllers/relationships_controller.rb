class RelationshipsController < ApplicationController 
  before_action :require_user
  def index
    @relationships = current_user.following_relationships
  end
  
  def create
  	Relationship.create(leader_id: params[:leader_id], follower_id: current_user.id) unless current_user.follows?(User.find(params[:leader_id]))
  	redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if current_user.following_relationships.include?(relationship)
    redirect_to people_path
  end
end