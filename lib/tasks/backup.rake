namespace :backup do
    desc "backup database"
    task db: :environment do
      settings = Rails.configuration.database_configuration[Rails.env]
      output_file = Rails.root.join('backups', "#{settings['database']}-#{Time.now.strftime('%Y%m%d-%H:%M')}.sql")
  
      system("/usr/bin/env mysqldump -h #{settings['host']} -u #{settings['username']} -p#{settings['password']} #{settings['database']} > #{output_file}")
    end
end