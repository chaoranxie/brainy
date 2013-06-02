class SearchController < ApplicationController
	def index


require 'google/api_client'
require 'json'
client = Google::APIClient.new
youtube = client.discovered_api('youtube', 'v3')
client.authorization = nil

		search_term= params[:search]

result = client.execute :key => ENV['GOOGLE_API_KEY'], :api_method => youtube.search.list, :parameters => {:q => search_term, :maxResults =>3 ,:part => 'snippet'}; nil
result = JSON.parse(result.data.to_json) ; nil
items = result['items'][0..2];nil
#item  = items.first

@view_items = []

items.each do |item|
view_item= {}
view_item['thumbnails'] =  item['snippet']['thumbnails']['default']
view_item['title'] = item['snippet']['title']
view_item['id'] = item['id']['videoId']
view_item['link'] = "http://www.youtube.com/watch?v=#{item['id']['videoId']}"
@view_items << view_item
end

        end	
end
