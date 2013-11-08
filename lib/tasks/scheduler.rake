require 'net/http'
desc "This task is called by the Heroku cron add-on"
task :call_page => :environment do
  p "Attempting to ping application at #{Time.now}"
  uri = URI.parse('http://www.goaliegoals.com/')
  r = Net::HTTP.get(uri)
  p "Completed ping at #{Time.now}"
end