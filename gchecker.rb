# encoding: UTF-8
require 'cgi'
require 'open-uri'
require 'hpricot'

page_num = 0
position = 0
#set maximum range of search -  10 pages
max_pages = 10
found = false

def msg_usage()
   puts "usage: " + $FILENAME + '"keyword\" \"domain\" \"optional-language\"'
end
if (ARGV.length < 2)
  msg_usage()
  exit
end

q = URI.encode(ARGV[0]).split
query = q.map! { |a| "#{a}"}.join("+")

domain = ARGV[1]

if ARGV[2]
  lang = ARGV[2]
  ext = lang
  if lang=='en_uk'
    ext = 'co.uk'
  end
else
  lang = 'en'
  ext = 'com'
end
=begin
add your proxy server below
for example:
proxy = ['46.186.107.102:80','93.157.103.243:80']
=end
proxy = []
proxy_used = proxy.sample
puts "You are using proxy: #{proxy_used}"

puts "Yua are searching in google.#{ext}\n"

begin
  while found == false and page_num < max_pages
    page_num += 1
    result_num = (page_num-1) * 10
    elements = Hpricot.parse(
      open(
      "http://google.#{ext}/search?q=#{query}&start=#{result_num}&sa=N&hl=#{lang}",'Proxy'=>proxy_used,'User-Agent'=>'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; pl-PL; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2')).search("li.g h3.r a")
    elements.each do |el|
      position += 1
    if (el.attributes['href'].include? domain)
      found = true
      puts "Website is a #{position} position"
      break
    end
  end
  end
  puts "Your website is beyond the scope of search ( #{max_pages*10} positions)" if found == false
rescue => e
  puts e.class, e.message
  puts "Probably you have to wait 24 hours for next check"
end

