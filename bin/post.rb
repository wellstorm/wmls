
require 'net/http'
require 'net/https'
require 'uri'
require 'stringio'


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
