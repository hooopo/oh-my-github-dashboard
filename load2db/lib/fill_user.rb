require 'fetch_batch_users'

class FillUser
  def self.run 
    Repo.where("user_id is null").where(is_in_organization: false).in_batches(of: 10) do |repos|
      FetchBatchUsers.new(repos).run
    end
  end
end