class Post < ActiveRecord::Base
	acts_as_taggable # Alias for acts_as_taggable_on :tags
	POST_TYPES=['Jobs', 'Cars for Sale', 'Properties for Sale', 'Things for Sale']
	scope :content_like, -> (content) { where("content ilike ?", content)}
	scope :category_like, -> (category) { where("category ilike ?", category)}
end
