require 'oauth'
require 'launchy'

class TwitterSession
  
  CONSUMER_KEY = File.read(".api_key")
  CONSUMER_SECRET = File.read(".secret_key")
  CONSUMER = OAuth::Consumer.new(
    CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

  def self.get(path, query_values)
    url = self.path_to_url(path, query_values)
    self.access_token.get(url).body
  end
  
  def self.post(path, req_params)
    url = self.path_to_url(path, req_params)
    self.access_token.post(url)
    Launchy.open("www.twitter.com")
  end
  
  def self.access_token
    @access_token ||= self.request_access_token
  end
  
  def self.request_access_token
    # Ask service for a URL to send the user to so that they may authorize
    # us.
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url

    # Launchy is a gem that opens a browser tab for us
    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)

    # Because we don't use a redirect URL; user will receive a short PIN
    # (called a **verifier**) that they can input into the client
    # application. The client asks the service to give them a permanent
    # access token to use.
    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp
    access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )
  end
  
  def self.path_to_url(path, query_values = nil)
    url = Addressable::URI.new(
      scheme: "https",
      host: "api.twitter.com",
      path: "1.1/#{path}.json",
      query_values: query_values
      ).to_s
  end
  

end