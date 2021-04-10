require 'restforce'
require 'dotenv'

Dotenv.load

# Takes in a connected Restforce client
Salesforce = Struct.new(:client) do
  def destroy(id)
    account = client.find('Account', id)
    puts "Deleting #{account.Name}"
    client.destroy('Account', id)
  end
end

# Create Restforce client
def create_client()
  client = Restforce.new(username: ENV['SALESFORCE_USERNAME'],
                         password: ENV['SALESFORCE_PASSWORD'],
                         security_token: ENV['SALESFORCE_SECURITY_TOKEN'],
                         client_id: ENV['SALESFORCE_CLIENT_ID'],
                         client_secret: ENV['SALESFORCE_CLIENT_SECRET'],
                         api_version: ENV['SALESFORCE_API_VERSION'])

  response = client.authenticate!
  info = client.get(response.id).body
  puts "#{info.user_id ? '' : 'NOT '}Connected!"
  Salesforce.new(client)
end

# Main
client = create_client()
