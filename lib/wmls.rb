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


require 'net/http'
require 'net/https'
require 'uri'
require 'stringio'
require 'rexml/document'

# A WITSML client library. 
#
# Author:: Hugh Winkler
# Copyright:: 2011 Wellstorm Development
# License:: Apache 2.0

# A WITSML client library. Construct an instance with the URL of the WITSML service,
# and credentials. Then call the WMLS methods, passing a WITSML query 
# template to each method.

class Wmls

  # The HTTP timeout in seconds (default 60)
  attr_accessor :timeout

  # Construct a new Wmls instance. 
  # url The URL of the remote WMLS service
  # user_name, password Credentials for the remote service

  def initialize (url, user_name, password)
    @url = url
    @user_name = user_name
    @password = password

    @optionsIn = ''
    @capabilitiesIn = ''
    @timeout = 60

    @envelope_begin = <<END
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:ns0="http://www.witsml.org/message/120">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
END

    @envelope_end = <<END
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
END
  end

  # call WMLS_AddToStore with the given template
  def add_to_store(template, optionsIn=nil)
    wmlTypeIn = extract_type(template)
    queryIn = escape_xml(template)
    soap_action = 'http://www.witsml.org/action/120/Store.WMLS_AddToStore'
    envelope_middle = <<END
        <ns0:WMLS_AddToStore SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <WMLtypeIn>#{wmlTypeIn}</WMLtypeIn>
            <XMLin>#{queryIn}</XMLin>
            <OptionsIn>#{optionsIn || @optionsIn}</OptionsIn>
            <CapabilitiesIn>#{@capabilitiesIn}</CapabilitiesIn>
        </ns0:WMLS_AddToStore>
END
    return send envelope_middle, soap_action
  end

  # call WMLS_DeleteStore with the given template
  def delete_from_store(template, optionsIn = nil)
    wmlTypeIn = extract_type(template)
    queryIn = escape_xml(template)
    soap_action = 'http://www.witsml.org/action/120/Store.WMLS_DeleteFromStore'
    envelope_middle = <<END
        <ns0:WMLS_DeleteFromStore SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <WMLtypeIn>#{wmlTypeIn}</WMLtypeIn>
            <QueryIn>#{queryIn}</QueryIn>
            <OptionsIn>#{optionsIn || @optionsIn}</OptionsIn>
            <CapabilitiesIn>#{@capabilitiesIn}</CapabilitiesIn>
        </ns0:WMLS_DeleteFromStore>
END
    return send envelope_middle, soap_action
  end

  # call WMLS_UpdateInStore with the given template
  def update_in_store(template, optionsIn=nil)
    wmlTypeIn = extract_type(template)
    queryIn = escape_xml(template)
    soap_action = 'http://www.witsml.org/action/120/Store.WMLS_UpdateInStore'
    envelope_middle = <<END
        <ns0:WMLS_UpdateInStore SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <WMLtypeIn>#{wmlTypeIn}</WMLtypeIn>
            <XMLin>#{queryIn}</XMLin>
            <OptionsIn>#{optionsIn || @optionsIn}</OptionsIn>
            <CapabilitiesIn>#{@capabilitiesIn}</CapabilitiesIn>
        </ns0:WMLS_UpdateInStore>
END
    return send envelope_middle, soap_action
  end
  
  # call WMLS_GetFromStore with the given template
  def get_from_store(template, optionsIn=nil)
    wmlTypeIn = extract_type(template)
    queryIn = escape_xml(template)
    soap_action = 'http://www.witsml.org/action/120/Store.WMLS_GetFromStore'
    envelope_middle = <<END
        <ns0:WMLS_GetFromStore SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <WMLtypeIn>#{wmlTypeIn}</WMLtypeIn>
            <QueryIn>#{queryIn}</QueryIn>
            <OptionsIn>#{optionsIn || @optionsIn}</OptionsIn>
            <CapabilitiesIn>#{@capabilitiesIn}</CapabilitiesIn>
        </ns0:WMLS_GetFromStore>
END
    return send envelope_middle, soap_action
  end

  def get_cap(optionsIn=nil)
    soap_action = 'http://www.witsml.org/action/120/Store.WMLS_GetCap'
    envelope_middle = <<END
        <ns0:WMLS_GetCap SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <OptionsIn>#{optionsIn || @optionsIn}</OptionsIn>
        </ns0:WMLS_GetCap>
END
    return send envelope_middle, soap_action
  end

  private

  # Replace special xml chartacters '&' and '<'
  def escape_xml(xml_in) 
    return xml_in.gsub(/&/,'&amp;').gsub(/</,'&lt;')
  end

  def pretty_xml(xml_data)
    s = ''
    doc = REXML::Document.new(xml_data)
    doc.write(s, 2)
    return s
  end

  # parse the xml and return the singular of the root element name.
  def extract_type(xml_data)
    doc = REXML::Document.new(xml_data)
    plural = doc.root.name
    return plural[0..plural.length-2]
  end

  #extract the witsml response: status_code and xml_out
  def extract_response(xml_data)
    doc = REXML::Document.new(xml_data)
    r = 0
    x = ''
    s = ''
    doc.root.each_element('//Result') { |elt| r = elt.text}  
    doc.root.each_element('//XMLout') { |elt| x = pretty_xml(elt.text)}  
    doc.root.each_element('//CapabilitiesOut') { |elt| x = pretty_xml(elt.text)}  
    doc.root.each_element('//SuppMsgOut') { |elt| s = elt.text }  
    return [r.to_i,s,x];
  end


  def post(io, url, user, pass, soap_action)    
    url = URI.parse(url)  if url.is_a? String
    io = StringIO.new(io) if io.is_a? String

    req = Net::HTTP::Post.new(url.path)
    req.basic_auth user, pass if user && user.length > 0
    req.body_stream = io

    #soap 1.1:
    req.add_field('SOAPAction', soap_action)
    req.content_type = 'text/xml' 

    #soap 1.2 would replace the above with:
    #req.content_type = "application/soap+xml; action=#{soap_action}"

    #req.content_length = io.stat.size
    req.content_length = io.size   # specific to StringIO class ? why no stat on that class?
    http = Net::HTTP.new(url.host, url.port)  
    http.use_ssl = (url.scheme == "https")
    http.read_timeout = @timeout # secs
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = http.start {|http2| http2.request(req) }

    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
      res
    else
      res.error!
    end
  end


  def send(envelope_middle, soap_action)
    envelope = @envelope_begin + envelope_middle + @envelope_end
    response = post(envelope, @url, @user_name, @password, soap_action)
    status, supp_msg, witsml = extract_response(response.body)
  end


end
