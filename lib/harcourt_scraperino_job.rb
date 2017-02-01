require 'rubygems'
require 'nokogiri'
require 'date'
require 'csv'
require 'open-uri'
require 'sanitize'
require 'rest_client'
require 'json'

class HarcourtScraperino
def get_ads(full_url, category)

  @category_page = Nokogiri::HTML(open(full_url))

  @titles = @category_page.css('div.listAddress h3').map { |title| title.text }

  @content_price = @category_page.css('div.propFeatures h3').map { |price| price.text || 0 }
  @content_bedrooms = @category_page.css('li.bdrm span').map { |bedrooms| bedrooms.text || "" }
  @content_desc =  @category_page.css('div.listingContent p').map { |desc| desc.text || "" }

  @titles.each_with_index do |title,index|
    begin
      content = @content_desc[index] + "\n" + "Bedrooms: " + @content_bedrooms[index]+ "\n" + "Price: " + @content_price[index]
      ad_upload(title, content, category)
      sleep(10)
    rescue => e
    puts "ERROR: #{e}"

    end
  end
end

def ad_upload(title,content,category)
  contact = "harcourtsfiji@connect.com.fj"

  request_body_map =({
                       title: title,
                       content: content,
                       contact: contact,
                       category: category
  })

  begin
  response = RestClient.post("#{HOST}",
                             request_body_map.to_json,    # Encode the entire body as JSON
                             {:content_type => 'application/json',
                              :accept => 'application/json'})
  
    puts "#{response.to_str}"
    puts "Response status: #{response.code}"
    response.headers.each { |k,v|
      puts "Header: #{k}=#{v}"
    }

  rescue => e
    puts "ERROR: #{e}"
  end # end json request
end


#main function

POST_TYPES={'Jobs'=>[3], 'Cars for Sale'=>[1], 'Properties for Sale'=>[32,33], 'Rent or Share'=>[27,26,30,34], 'Things for Sale'=>[11,12]}

HOST = 'http://www.matenalavo.com/posts'

def main

get_ads('http://harcourts.co.nz/Property/Rentals/All/Fiji?view=list', 'Rent or Share')
get_ads('http://harcourts.co.nz/Property/Residential', 'Properties for Sale')
end
end