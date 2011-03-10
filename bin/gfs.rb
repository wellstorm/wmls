#!/usr/bin/env ruby -w
# Copyright 2011 Wellstorm Development LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


require 'optparse'
require 'net/http'
require 'net/https'
require 'uri'
require 'stringio'
require 'rexml/document'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: gfs.rb [options]"
  opts.on("-v", "--verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on("-r", "--url url", "URL of the WITSML service") do |v|
    options[:url] = v
  end
  opts.on("-u", "--username USER", "HTTP user name") do |v|
    options[:user_name] = v
  end
  opts.on("-p", "--password PASS", "HTTP password") do |v|
    options[:password] = v
  end
  opts.on("-q", "--query QUERY", "Path to file containing query template") do |v|
    options[:query] = v
  end
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

p options

def get_file_as_string(filename)
  data = ''
  f = File.open(filename, "r") 
  f.each_line do |line|
    data += line
  end
  return data
end

def escape_xml(xmlIn) 
  return xmlIn.gsub(/&/,'&amp;').gsub(/</,'&lt;')
end

def extract_type(xml_data)
  doc = REXML::Document.new(xml_data)
  plural = doc.root.name
  return plural[0..plural.length-2]
end

def post(io, url, user, pass, soap_action)    
  url = URI.parse(url)
  io = StringIO.new(io)

  req = Net::HTTP::Post.new(url.path)
  req.basic_auth user, pass
  req.body_stream = io
  req.add_field('SOAPAction', soap_action)
  req.content_type = 'application/soap+xml'
  #req.content_length = io.stat.size
  req.content_length = io.size   # specific to StringIO class ? why no stat on that class?
  http = Net::HTTP.new(url.host, url.port)  
  http.use_ssl = true
  http.read_timeout = 60 # secs

  res = http.start {|http2| http2.request(req) }

  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    # OK
    res
  else
    res.error!
  end
end


xmlIn = get_file_as_string(options[:query])
wmlTypeIn = extract_type(xmlIn)
queryIn = escape_xml(xmlIn);
optionsIn = ''
capabilitiesIn = ''

envelope = <<END
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns0="http://www.witsml.org/message/120">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <ns0:WMLS_GetFromStore SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <WMLtypeIn>#{wmlTypeIn}</WMLtypeIn>
            <QueryIn>#{queryIn}</QueryIn>
            <OptionsIn>#{optionsIn}</OptionsIn>
            <CapabilitiesIn>#{capabilitiesIn}</CapabilitiesIn>
        </ns0:WMLS_GetFromStore>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
END
soap_action = 'http://www.witsml.org/action/120/Store.WMLS_GetFromStore'
response = post(envelope, options[:url],  options[:user_name], options[:password], soap_action)


#p envelope
p  response.body
