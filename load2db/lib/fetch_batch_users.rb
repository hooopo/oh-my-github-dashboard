class FetchBatchUsers

  attr_reader :repos, :owners
  def initialize(repos)
    @repos = repos
    @owners = repos.map(&:owner).uniq
  end

  def query
    fragments = owners.map do |owner|
      <<~USER
        #{normalize_login(owner)}: user(login: "#{owner}") {
          ...UserFragment
        }
      USER
    end.join("\n")

    <<~GQL
      query {
        rateLimit {
          limit
          cost
          remaining
          resetAt
        }
 
        #{fragments}
      }

      fragment UserFragment on User {
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

    GQL
  end

  def get_attrs(data)
    owners.map do |owner|
      base = data.dig("data", normalize_login(owner))
      {
        id: base.dig("databaseId"),
        login: base["login"],
        company: base["company"],
        twitter_username: base["twitterUsername"],
        location: base["location"],
        created_at: base["createdAt"],
        updated_at: base["updatedAt"],
        followers_count: base.dig("followers", "totalCount"),
        following_count: base.dig("following", "totalCount")
      }
    end
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
    attrs.each do |attr|
      Repo.where(owner: attr[:login]).update_all(user_id: attr[:id])
    end
    User.upsert_all(attrs)
  end

  def normalize_login(login)
    str = login.gsub("-", "_")
    str = "_" + str if str.start_with?(/\d/)
    str
  end

end

