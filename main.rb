#!/usr/bin/env ruby -w
# Copyright 2011 Wellstorm Development LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


require 'optparse'
require 'wmls'
options = {}

opts =OptionParser.new do |o|
  o.banner = "Usage: wmls.rb [options]"
#  o.on("-v", "--verbose", "Run verbosely") do |v|
#    options[:verbose] = v
#  end
  o.on("-r", "--url url", "URL of the WITSML service") do |v|
    options[:url] = v
  end
  o.on("-u", "--username USER", "HTTP user name (optional)") do |v|
    options[:user_name] = v
  end
  o.on("-p", "--password PASS", "HTTP password (optional)") do |v|
    options[:password] = v
  end
  o.on("-q", "--query QUERYFILE", "Path to file containing query, delete, add or update template. (optional, default stdin)") do |v|
    options[:query] = v
  end
  o.on("-a", "--action ACTION", [:add,:get,:update,:delete], "WITSML action: add, get, update, or delete (optional, default 'get')") do |v|
    options[:action] = v || :get
  end
  o.on_tail("-h", "--help", "Show this message") do
    puts o
    exit
  end
end


# Load the named file and return its contents as a string
def get_file_as_string(filename)
  data = ''
  if(filename)
    f = File.open(filename, "r")
  else
    f = $stdin
  end

  f.each_line do |line|
    data += line
  end
  return data
end


opts.parse!
if ( !options[:url] )
  puts(opts.help)
  exit 1
end


template= get_file_as_string(options[:query] )

case options[:action]
  when :add
  result = Wmls::add_to_store(template)
  when :delete
  result = Wmls::delete_from_store(template)
  when :update
  result = Wmls::update_in_store(template)
  when :get,Nil
  result = Wmls::get_from_store(template)
  else
  raise "unsupported action #{options[:action]}"
end


status, supp_msg, witsml = result
if (status != 1)
  $stderr.puts "Error #{status}: #{supp_msg}"
else
  $stdout.puts witsml
end
