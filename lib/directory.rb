#!/usr/bin/env ruby
# Written by Edwin Millan-Rodriguez
# Assistance from Errin Larsen with Refactoring
# Digium Switchvox API Documentation URL: http://developers.digium.com/switchvox/

require "httparty"
require "json"
require "prawn"
require "open-uri"

class Extension
  attr_accessor :ext, :type, :display_name

  def initialize(extension)
    @ext          = extension["number"]  || "unkn"
    @type         = extension["type"]    || "unkn"
    @display_name = extension["display"] || "unkn"
  end

  def accepted?
    return accepted_types?(type)
  end

  def to_s
    return "Extension #{ext}\n  Display Name: #{display_name}\n  Type: #{type}"
  end

  def to_a
    return [display_name,ext]
  end

  private
  def accepted_types
    return %w[sip ivr call_queue conference simple_conference virtual]
  end
end

class Directory
  
  def initialize(options = {})
    @url      = options[:url]      || raise_argument_error(:url)
    @username = options[:username] || raise_argument_error(:username)
    @password = options[:password] || raise_argument_error(:password)
    @method   = options[:method]   || raise_argument_error(:method)
    @auth = { username: @username, password: @password }
    @parameters = options[:parameters] || {}
  end

  def accepted?(t)
    accepted_types = ["sip","ivr","call_queue","conference","simple_conference","virtual"]
    return accepted_types.include?(t)
  end

  def response
    json_body = {request: {method: @method, parameters: @parameters}}.to_json
    options = {
      body: json_body,
      digest_auth: @auth
    }
    return response = HTTParty.post(@url, options)
  end

  def count
    return count_exts(response)
  end

  def list_extensions(*blacklist)
    extensions(response).map do |raw|
      extension = Extension.new(raw)
      puts extension unless blacklist.include?(extension.ext)
    end
    return nil
  end

  def export_extensions(*blacklist)
    return extensions(response).map! do |raw|
      extension = Extension.new(raw)
      extension.to_a unless blacklist.include?(extension.ext)
    end
  end

  private
  
  def extensions(response)
    body = JSON.parse(response.body)
    return body["response"]["result"]["extensions"]["extension"]
  end

  def count_exts(response)
    body = JSON.parse(response.body)
    return body["response"]["result"]["extensions"]["total_items"].to_i
  end

  def raise_argument_error(arg)
    raise ArgumentError, "You must include a #{arg.inspect} option when calling Directory.new"
  end
end

# Example calls
# require 'directory'
# d = Directory.new(
#   { 
#     username: "api_username",
#     password: "password",
#     url: "https://SWITCHVOX_IP/json",
#     method: "switchvox.extensions.search",
#     parameters: {"items_per_page" => "500"}
#   }
# )

# e = Directory.new(
#   { 
#     username: "api_username",
#     password: "password",
#     url: "https://SWITCHVOX_IP/json",
#     method: "switchvox.extensions.getInfo",
#     parameters: {"extensions" => ["1234"]}
#   }
# )