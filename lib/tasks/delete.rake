# lib/tasks/delete_old_records.rake
namespace :delete do
  desc 'Delete records older than 6 months'
  task :old_records => :environment do
    Post.delete_all("created_at < '#{180.days.ago}'")
    end
    task :duplicate_records => :environment do
    	contents_with_multiple = Post.group(:content).having("count(content) > 1").count.keys
    	contents_with_multiple.each do |key|
    		duplicates = Post.where(content: key).order("created_at desc").offset(1).all
    		duplicates.destroy_all
      end
	  end
  end

