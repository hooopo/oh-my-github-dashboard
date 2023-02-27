require 'http'

class FetchCurrentUser 
  attr_reader :login

  def initialize(login)
    raise "user login required" if login.blank?
    @login = login
  end

  def query 
    q = <<~GQL
    query {
      user(login: "#{login}") {
        databaseId
        name
        login
        company
        location
        twitterUsername
        bio
        createdAt
        updatedAt
        
        following {
          totalCount
        }
        followers {
          totalCount
        }
      }
    }
    GQL
  end

  def get_attrs(data)
    base = data.dig("data", "user")
    {
      id: base.dig("databaseId"),
      login: base["login"],
      company: base["company"],
      twitter_username: base["twitterUsername"],
      bio: base["bio"],
      location: base["location"],
      created_at: base["createdAt"],
      updated_at: base["updatedAt"],
      followers_count: base.dig("followers", "totalCount"),
      following_count: base.dig("following", "totalCount"),
      region: base["location"] && Geocoder.search(base["location"])&.first&.country
    }
  end

  def run 
    response = HTTP.post("https://api.github.com/graphql",
      headers: {
        "Authorization": "Bearer #{ENV['ACCESS_TOKEN']}",
        "Content-Type": "application/json"
      },
      json: { query: query }
    )

    data = response.parse
    attrs = get_attrs(data)
    user = CurrentUser.upsert(attrs)
    user
  end
end
