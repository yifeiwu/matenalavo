class Post < ActiveRecord::Base
	acts_as_taggable # Alias for acts_as_taggable_on :tags
	POST_TYPES=['Job Vacancies', 'Cars for Sale', 'Properties for Sale']
end
