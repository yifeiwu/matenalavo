class Post < ActiveRecord::Base
	include PgSearch

	POST_TYPES=['Jobs', 'Cars for Sale', 'Properties for Sale', 'Things for Sale', 'Something Else']
	validates :title,:contact,:content, presence: true
  validates :title, length: { maximum: 40 }




  mount_uploader :postpic, PostpicUploader


  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :search_any_word,
      :post_category,
      :post_date
    ]
    )

  # ActiveRecord association declarations

  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.
  
  pg_search_scope :search_query, 
  :against => [:content, :title], 
  :order_within_rank => "posts.updated_at DESC",
  :using =>{
  	:tsearch => {:prefix => true}
  }

  pg_search_scope :search_any_word,
  :against => [:content, :title], 
  :order_within_rank => "posts.updated_at DESC",
  :using =>{
    :tsearch => {:any_word => true}
  }


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
  scope :post_date, lambda { |post_date|
    where('posts.created_at >= ?', post_date)
  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.


  def similar_posts
    query= "SELECT p.id, ts_rank_cd(to_tsvector('english', p.content), replace(plainto_tsquery(original.content)::text, ' & ', ' | ')::tsquery) AS similarity
    FROM posts p,
    (SELECT content, id FROM posts WHERE id = ? LIMIT 1) AS original
    WHERE p.id != original.id
    ORDER BY similarity DESC
    LIMIT 3;"

    sim_ids = Post.find_by_sql( [query,self.id] )
    similar_array = Post.find(sim_ids)
    return similar_array
  end


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
   ['Something Else', 'Something Else']
 ]
end
def self.options_for_post_date
  [   ['Any' , ''],
  ['Last week', Time.now - 7.day],
  ['Last 2 weeks', Time.now - 14.day],
  ['Last 30 days', Time.now - 30.day],
]
end

end








