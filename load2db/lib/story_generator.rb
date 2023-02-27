class StoryGenerator
  # Generate story by github api
  # 
  def self.generate_by_openai 
    if ENV["OPENAI_TOKEN"].blank?
      puts("OPENAI_TOKEN env missing, please set it, if you want to generator our github story by OpenAI")
      return
    end
    current_user = CurrentUser.first
    return if current_user.story.present?

    client = OpenAI::Client.new(access_token: ENV["OPENAI_TOKEN"])
    current_user = CurrentUser.first
    repos_count = Repo.where(user_id: current_user.id).where(is_fork: false).count
    most_starred_repos = Repo.where(user_id: current_user.id).order(stargazer_count: :desc).limit(3).map{|x|  "#{x.owner}/#{x.name}"}.join(",")
    most_used_languages = Repo.where(user_id: current_user.id).where(is_fork: false).group(:language).select("language, count(*) as count").order("2 desc").where("language is  not null").limit(3).map{|x| x.language}.join(",")

    prompt = ""
    prompt += "This is a story about a github user named #{ENV['USER_LOGIN']}\n"
    prompt += "Joined github at: #{current_user.created_at}\n"
    prompt += "Location: #{current_user.region || current_user.location } \n"
    prompt += "Company: #{current_user.company || "freelancer"} \n" if current_user.company.present?
    prompt += "Following: #{current_user.following_count} \n"
    prompt += "Followers: #{current_user.followers_count} \n"
    prompt += "Most starred repos created by him: #{most_starred_repos} \n"
    prompt += "Most used languages: #{most_used_languages} \n"
    prompt += "He has #{repos_count} repos. "
    prompt += "Bio: #{current_user.bio} \n"
    prompt += "Twitter username: #{current_user.twitter_username} \n" if current_user.twitter_username.present?
    prompt += "Write a story about #{current_user.login}, include information above. Minimum 800 words. A paragraph has a maximum of 140 characters."
    
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: prompt,
        max_tokens: 2024
      }
    )
    story = response["choices"].map { |c| c["text"] }.join("\n\n") rescue nil
    current_user.update(story: story) if story.present?
  end
end