require 'rubygems'
require 'nokogiri'
require 'date'
require 'csv'
require 'open-uri'
require 'sanitize'
require 'rest_client'
require 'json'

def get_ads(cid,category)

  base_part = "http://classifieds.fijitimes.com/"
  cat_part = "class.aspx?cid="
  date_part = (Time.now-86400).strftime("&date=%Y-%m-%d")
  full_url = base_part+cat_part+cid.to_s+date_part


  @category_page = Nokogiri::HTML(open(full_url))


  @titles =Array.new
  @titles = @category_page.css('div#r1 a').map { |link| link.text }
  @titles = @titles.concat(@category_page.css('div#r2 a').map { |link| link.text })
  @titles = @titles.concat(@category_page.css('div#r3 a').map { |link| link.text })


  @category_links = @category_page.css('div#r1 a').map { |link| link['href'] } #column1
  @category_links = @category_links.concat(@category_page.css('div#r2 a').map { |link| link['href'] }) #tack on column2
  @category_links = @category_links.concat(@category_page.css('div#r3 a').map { |link| link['href'] }) #finally 3

  @category_ads=Array.new

  @category_links.each do |category_link|

    url= base_part+category_link
    doc = Nokogiri::HTML(open(url))
    contents = doc.css('div.c1')
    contents = clean_body(contents.to_html)
    @category_ads.push(contents)

  end

  @titles.zip(@category_ads).each do |title, content|
    next unless content.to_str.length > 5 #check for blanks
    ad_upload(title, content, category)
    sleep(10)
  end
end

def ad_upload(title,content,category)
  contact = "See posting"

  request_body_map =({
                       title: title,
                       content: content,
                       contact: contact,
                       category: category
  })


  response = RestClient.post("#{HOST}",
                             request_body_map.to_json,    # Encode the entire body as JSON
                             {:content_type => 'application/json',
                              :accept => 'application/json'})
  begin
    #puts "#{response.to_str}"
    #puts "Response status: #{response.code}"
    response.headers.each { |k,v|
      puts "Header: #{k}=#{v}"
    }

  rescue => e
    puts "ERROR: #{e}"
  end # end json request
end

def clean_body(text)
  text.gsub!(/(\r)?\n/, "<br>");
  text.gsub!(/\s+/, ' ');
  text = Sanitize.clean(text, :elements => ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p', 'a', 'b', 'strong', 'em', 'img', 'iframe'],
                        :attributes => {
                          'a' => ['href', 'title', 'name'],
                          'iframe' => ['src', 'url', 'class', 'id', 'width', 'height', 'name'],
                        },
                        :protocols => {
                          'a' => {
                            'href' => ['http', 'https', 'mailto']
                          },
                          'iframe' => {
                            'src' => ['http', 'https']
                          }
  },)
  text.strip!
end

#main function

POST_TYPES={'Jobs'=>[3], 'Cars for Sale'=>[1], 'Properties for Sale'=>[32,33], 'Rent or Share'=>[27,26,30,34], 'Things for Sale'=>[11,12]}

HOST = 'http://www.matenalavo.com/posts'

POST_TYPES.each do |k,v|
    v.each do |subv|
      get_ads(subv,k)
    end
  end

