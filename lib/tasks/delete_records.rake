# lib/tasks/delete_records.rake
namespace :delete_records do
  desc 'Delete records older than 6 months'
  task old: :environment do
    Post.delete_all("created_at < '#{180.days.ago}'")
  end
  task duplicates: :environment do
    contents_with_multiple = Post.group(:content).having('count(content) > 1').count.keys
    contents_with_multiple.each do |key|
      duplicates = Post.where(content: key).order('created_at desc').offset(1).all
      duplicates.destroy_all
    end
  end
end
