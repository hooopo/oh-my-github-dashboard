require 'http'

class FetchCommitComments
  attr_reader :login, :current_user

  def initialize(login)
    @login = login
    @current_user = CurrentUser.where(login: login).first
    raise "current user not found" if @current_user.nil?
  end

  def query(cusor)
    if cusor 
      after = %Q|, after: "#{cusor}"|
    else
      after = ''
    end
    <<~GQL
      query {
        rateLimit {
          limit
          cost
          remaining
          resetAt
        }
        user(login: "#{login}") {
          commitComments(first: 100 #{after}) {
            pageInfo {
              endCursor
              hasNextPage
            }
            edges {
              node {
                databaseId
                authorAssociation
                createdAt
                updatedAt
                repository {
                  databaseId
                }
              }
            }
          }
        }
      }
    GQL
  end

  def run
    cusor =  current_user.last_commit_comment_cursor
    remaining_count ||= 5000
    is_has_next_page = true
    loop do 
      # puts cusor 
      # puts remaining_count
      # puts is_has_next_page

      data = fetch_data(cusor)
      attrs = get_attr_list(data)
      if attrs.blank?
        puts "All commit comment synced successed"
        break
      else
        CommitComment.upsert_all(attrs)
      end
      cusor = end_cusor(data)
      
      remaining_count = remaining(data)
      is_has_next_page = has_next_page(data)
      current_user.update(last_commit_comment_cursor: cusor) if cusor.present?
      if remaining_count == 1
        puts "You do not have enough remaining ratelimit, please try it after an hour."
        break
      end

      if not is_has_next_page
        puts "All commit comments synced successed"
        break
      end
    end
  end

  def fetch_data(cusor)
    q = query(cusor)
    puts "- Sync commit comments with cusor: #{cusor}"
    response = HTTP.post("https://api.github.com/graphql",
      headers: {
        "Authorization": "Bearer #{ENV['ACCESS_TOKEN']}",
        "Content-Type": "application/json"
      },
      json: { query: q }
    )
    response.parse
  end

  def remaining(data)
    data.dig("data", "rateLimit", "remaining")
  end

  def end_cusor(data)
    data.dig("data", "user", "commitComments", "pageInfo", "endCursor")
  end

  def has_next_page(data)
    data.dig("data", "user", "commitComments", "pageInfo", "hasNextPage")
  end

  def get_attr_list(data)
    edges = data.dig("data", "user", "commitComments", "edges")
    if edges.nil?
      puts data["errors"]
      raise "GitHubb API issue, please try again later"
    end
    edges.map do |edge|
      hash = edge["node"]
      {
        repo_id: hash.dig("repository", "databaseId"),
        id: hash["databaseId"],
        created_at: hash["createdAt"],
        updated_at: hash["updatedAt"],
        author_association: hash["authorAssociation"],
        user_id: current_user.id
      }
    end
  end
end
