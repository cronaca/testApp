class Comment < ActiveRecord::Base
	attr_accessible :content
	belongs_to :microposts
	validates :user_id, :micropost_id, :user_id, presence: true
	
	default_scope order: 'comments.created_at DESC'
end
