require 'rake'
load "Rakefile"

require 'retryable'

class RetryableRake 
  def self.db_migrate 
    Retryable.retryable(tries: 10, matching: /Lost connection to MySQL server/) do |retries, exception|
      puts "Retrying #{retries} times due to #{exception}" if retries > 0
      Rake::Task['db:migrate'].invoke
    end
  end

  def self.db_create 
    Retryable.retryable(tries: 10, matching: /Lost connection to MySQL server/) do |retries, exception|
      puts "Retrying #{retries} times due to #{exception}" if retries > 0
      Rake::Task['db:create'].invoke
    end
  end
end

