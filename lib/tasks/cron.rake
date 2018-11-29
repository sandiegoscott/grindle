desc "This task is called by the Heroku cron add-on"
task :cron => :environment do

  #
  # daily jobs
  #

  # database backup
  if Rails.env == 'production'
    HerokuBackupTask.execute
  end

end

