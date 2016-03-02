# lib/tasks/delete_old_records.rake
namespace :replace do
  desc 'Replace words, fragments'
  task :frags => :environment do
    	posts = Post.all
    	posts.each do |post|
    		post.content = post.content.gsub(/\/i+/,' ')
        post.title = post.title.gsub(/\/i+/,' ')
        post.title = post.title.gsub(/vacancy/i,'').titleize

    		post.save
      end
	  end
  end

