class Post < ActiveRecord::Base
	acts_as_taggable # Alias for acts_as_taggable_on :tags
	POST_TYPES=['Jobs', 'Cars for Sale', 'Properties for Sale', 'Things for Sale']
end
