class UserFollowSerializer < ActiveModel::Serializer
  attributes :id, :follower_id, :followed_id
end
