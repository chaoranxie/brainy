class SearchController < ApplicationController
	def index
		search_term= params[:search]
		@youtube_items = youtube_search(search_term)
		@meetup_items = meetup_search(search_term)

        end


  def youtube_search(search_string)
require 'google/api_client'
require 'json'
client = Google::APIClient.new
youtube = client.discovered_api('youtube', 'v3')
client.authorization = nil

search_term= search_string

result = client.execute :key => ENV['GOOGLE_API_KEY'], :api_method => youtube.search.list, :parameters => {:q => search_term, :maxResults =>3 ,:part => 'snippet'}; nil
result = JSON.parse(result.data.to_json) ; nil
items = result['items'][0..2];nil
#item  = items.first

view_items = []

items.each do |item|
view_item= {}
view_item['title'] = item['snippet']['title']
view_item['thumbnails'] =  item['snippet']['thumbnails']['default']
view_item['id'] = item['id']['videoId']
view_item['link'] = "http://www.youtube.com/watch?v=#{item['id']['videoId']}"
view_items << view_item
end
   return view_items	

  end


  def meetup_search(search_term)

  string = search_term
  #string = " learning guitart "
  search_string = string.strip.gsub(' ', '+')
  get_url = "http://api.meetup.com/2/open_events?status=upcoming&radius=25.0&state=ma&and_text=False&limited_events=False&text=#{search_string}&desc=False&city=Boston&offset=0&format=json&page=20&key=151963107c6ba2033403c2a9114660"
  require 'httparty'
  response = HTTParty.get(get_url)
  result_objects = []
  response['results'].each do |event|

    #event = response['results'].first
    result_object = {}
#    result_object['event_url'] = event['event_url']
    result_object['name'] = event['name']
#    result_object['description'] = event['description']
#    result_object['time'] = event['time']
    result_object['group'] = event['group']['name']
    result_objects << result_object
  end 
    return result_objects

  end



	
end
