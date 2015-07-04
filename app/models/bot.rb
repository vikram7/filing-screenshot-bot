require 'capybara/poltergeist'
require 'csv'
require 'json'
require 'rest_client'
require 'pry'
require 'httparty'

class Bot
  attr_reader :filename
  def initialize(filename)
    @filename = filename
  end

  def populate!
    urls = Array.new

    puts 'bot waking up...'

    puts 'Reading from CSV'
    CSV.foreach(filename, headers: true) do |row|
      http_location = row["http_location"]
      urls << http_location
    end
    puts 'Reading CSV complete'

    puts 'Getting files and saving as htmls'
    filenames = Array.new
    urls[0..3].each_with_index do |url, index|
      body = HTTParty.get(url)
      length = body.length
      relevant_length = length / 10
      body = body[0..relevant_length]

      filename = "temp/filings/file#{index}.html"
      filenames << filename
      File.open(filename, 'w') do |file|
        file.write(body)
      end
    end

    Capybara.configure do |config|
      config.run_server = false
      config.default_driver = :poltergeist
      # config.app_host = 'http://base_url.com/' # change url
    end

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, { window_size: [1600, 3500] })
    end

    s = Capybara::Session.new(:poltergeist)

    puts 'Logging in'

    filenames.each_with_index do |filename, index|
      puts "visiting #{filename}"
      s.visit filename
      s.driver.save_screenshot("temp/images/
        file#{index}.png")
      puts "screenshot saved for #{filename}"
    end

  end

end
