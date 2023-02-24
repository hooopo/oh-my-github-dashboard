class SyncRegion 
  def run 
    User.where("location is not null and location <> '' and region is null").limit(5000).each do |user|
      region = Geocoder.search(user.location)&.first&.country
      region = 'N/A' if region.blank?
      user.update(region: region)
    end
  end
end