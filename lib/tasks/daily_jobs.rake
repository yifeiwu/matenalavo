# lib/tasks/daily_jobs.rake

namespace :daily_jobs do

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

  task :uploads do
    begin
      require Rails.root.join('lib', 'scraperino_job.rb').to_s
      ruby "scraperino_job.rb"
    rescue => e
      puts "ERROR: #{e}"
    end # end json re
  end

  task :all => [:uploads, :duplicates, :old]
end
