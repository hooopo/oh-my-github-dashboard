class SyncGithub
  def self.run!
    raise("USER_LOGIN env missing, please set it") if ENV["USER_LOGIN"].blank?
    
    puts "👉 Sync current user info #{ENV['USER_LOGIN']}"
    FetchCurrentUser.new(ENV["USER_LOGIN"]).run 

    puts "👇 Sync Issues"
    FetchIssues.new(ENV["USER_LOGIN"]).run

    puts "👇 Sync PullRequests"
    FetchPullRequests.new(ENV["USER_LOGIN"]).run

    puts "👇 Sync Repos"
    FetchRepos.new(ENV["USER_LOGIN"]).run

    puts "👇 Sync Starred Repos"
    FetchStarredRepos.new(ENV["USER_LOGIN"]).run

    puts "👇 Sync Followers"
    FetchFollowers.new(ENV["USER_LOGIN"]).run

    puts "👇 Sync Followings"
    FetchFollowings.new(ENV["USER_LOGIN"]).run

    puts "👇 Sync Issue Comments"
    FetchIssueComments.new(ENV["USER_LOGIN"]).run

    puts "👇 Sync Commit Comments"
    FetchCommitComments.new(ENV["USER_LOGIN"]).run

    puts "👇 Sync Region"
    SyncRegion.new.run
  end
end