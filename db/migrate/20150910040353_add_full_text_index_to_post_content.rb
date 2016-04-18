class AddFullTextIndexToPostContent < ActiveRecord::Migration
  def up
    execute "CREATE INDEX ON posts USING gin(to_tsvector('english', content));"
  end

  def down
    execute 'DROP INDEX posts_to_tsvector_idx'
  end
end
