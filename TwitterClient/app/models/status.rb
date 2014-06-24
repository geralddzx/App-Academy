# == Schema Information
#
# Table name: statuses
#
#  id                :integer          not null, primary key
#  body              :string(255)      not null
#  twitter_status_id :string(255)      not null
#  twitter_user_id   :string(255)      not null
#

class Status < ActiveRecord::Base
  
  def self.fetch_by_twitter_user_id!(twitter_user_id)
    status = TwitterSession.get(
      "statuses/user_timeline", 
      {user_id: twitter_user_id}
    )
    result = JSON.parse(status).map {|status| self.parse_json(status)}
    save_many(result, twitter_user_id)
    result
  end
  
  def self.parse_json(status)
    {
      body: status["text"], 
      twitter_status_id: status["id_str"], 
      twitter_user_id: status["user"]["id_str"]
    }
  end
  
  def self.get_old_status_ids(user_id)
    self.where(twitter_user_id: twitter_user_id).pluck(:twitter_status_id).to_a
  end
  
  def self.save_many(statuses, user_id)
    get_old_status_ids(user_id)
    
  
end
