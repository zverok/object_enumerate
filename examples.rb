require_relative 'lib/object_enumerate'
require 'pp'

# Most idiomatic "infinite sequence" possible:
p 1.enumerate(&:succ).take(5)

# Easy Fibonacci
p [0, 1].enumerate { |f0, f1| [f1, f0 + f1] }.take(10).map(&:first)

require 'date'

# Find next Tuesday
Date.today.enumerate(&:succ).detect { |d| d.wday == 2 }

require 'nokogiri'
require 'open-uri'

# Find some element on page, then make list of all parents
p Nokogiri::HTML(open('https://www.ruby-lang.org/en/'))
  .at('a:contains("Ruby 2.2.10 Released")')
  .enumerate(&:parent)
  .take_while { |node| node.respond_to?(:parent)  }
  .map(&:name)

require 'octokit'

Octokit.stargazers('rails/rails')
# ^ this method returned just an array, but have set `.last_response` to full response, with data
# and pagination. So now we can do this:
p Octokit.last_response
  .enumerate { |response| response.rels[:next].get } # pagination: `get` fetches next Response
  .first(3) # take just 3 pages of stargazers
  .flat_map(&:data) # data is parsed response content (stargazers themselves)
  .map { |h| h[:login] }
