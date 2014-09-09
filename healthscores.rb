require 'twilio-ruby'
require 'sinatra'
require 'httparty'
 
get '/healthscores' do
  sender = params[:From]
  body = params[:Body]
  restaurant_name = body.gsub("'","") # Handles when a single quote is in name like Wendy's

  # Basic setup of api endpoint, datasets and headers for requests
  civic_data_url = 'http://www.civicdata.com/api/action/datastore_search_sql'
  businesses_resource_id = '386efa42-7a88-4b0a-8c3e-50add92e9369'
  inspections_resource_id = 'b5a32cf2-3bf3-47ae-b3c9-f2f55dc96f8c'
  headers = { 'Content-Type' =>'application/json', 'Accept' => 'application/json'}

  # Query a list of businesses based on body of SMS
  businesses_query = "SELECT * from \"#{businesses_resource_id}\" where upper(replace(\"name\",$$'$$,$$$$)) LIKE '#{restaurant_name.upcase}%'"
  @businesses_data = HTTParty.get(civic_data_url, :headers => headers, :query => {:sql => businesses_query})
  business_data = @businesses_data.parsed_response["result"]["records"]
  
  if business_data.any? # If data is returned
    
    # For now just grab the first business returned, longer term implement conversation feature
    # to allow user to select which address
    restaurant = business_data.first

    # Query a list of inspections based on business id.
    inspections_query = "SELECT * from \"#{inspections_resource_id}\" where \"business_id\" = '#{restaurant["business_id"]}'"
    @inspections_data = HTTParty.get(civic_data_url, :headers => headers, :query => {:sql => inspections_query})      
    inspections_data = @inspections_data.parsed_response["result"]["records"]

    inspections_data.sort! { |id1, id2| id2["date"] <=> id1["date"] }
    
    latest_inspection = inspections_data.first

    puts latest_inspection["score"]

    inspection_date = Date.parse latest_inspection["date"]

    message = "Restaurant Name: #{restaurant['name']}\n"
    message += "Address: #{restaurant["address"].split(" ").map(&:capitalize).join(" ")}, #{restaurant["city"]} #{restaurant["state"]}, #{restaurant["postal_code"]}\n"
    message += "Last Inspection Date: #{inspection_date.strftime("%m/%d/%Y")}\n"
    message += "Health Score: #{latest_inspection['score']}/100"
    
  else #No business found
    message = "No restaurant found with the name #{body}"
  end

  #Send the response
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message message
  end
  twiml.text
end