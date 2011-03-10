require 'optparse'
require 'rexml/document'

require 'post'

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
