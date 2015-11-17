# lib/tasks/delete_old_records.rake
namespace :delete do
  desc 'Delete records older than 60 days'
  task :old_records => :environment do
    Post.delete_all("created_at < '#{60.days.ago}'")
    end
  end
