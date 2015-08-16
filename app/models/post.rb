class Post < ActiveRecord::Base
	include PgSearch
	acts_as_taggable # Alias for acts_as_taggable_on :tags
	POST_TYPES=['Jobs', 'Cars for Sale', 'Properties for Sale', 'Things for Sale', 'Something Else']
	validates :title,:contact,:content, presence: true

  

  	mount_uploader :postpic, PostpicUploader


filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :post_category

    ]
  )

  # ActiveRecord association declarations

  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.
  
  pg_search_scope :search_query, 
  :against => [:content, :title], 
  :using => [:tsearch],
  :order_within_rank => "posts.updated_at DESC"

   scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      reorder("posts.created_at #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
   scope :post_category, lambda { |category_ids|
    where("posts.category ilike ?", category_ids)
  }
 

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [

      ['Newest first', 'created_at_desc'],
      ['Oldest first', 'created_at_asc'],
    ]
  end
  
  def self.options_for_post_category
    	[	['Any' , '%'],
      		['Things for Sale', 'Things for Sale'],
      		['Cars for Sale', 'Cars for Sale'],
      		['Properties for Sale', 'Properties for Sale'],
      		['Job Vacancies', 'Jobs'],

    	]
    end

end








