class Repo < ApplicationRecord
  has_many :issues
  has_many :pull_requests
end
