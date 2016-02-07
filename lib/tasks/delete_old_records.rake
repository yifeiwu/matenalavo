# lib/tasks/delete_old_records.rake
namespace :delete do
  desc 'Delete records older than 4 months'
  task :old_records => :environment do
    Post.delete_all("created_at < '#{120.days.ago}'")
    end
    task :duplicate_records => :environment do
    	titles_with_multiple = Post.group(:title).having("count(title) > 1").count.keys
    	titles_with_multiple.each do |key|
		duplicates = Post.where(title: key).order("created_at desc").offset(1).all
		duplicates.destroy_all
	end



	end
  end

