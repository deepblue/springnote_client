%w(rubygems rest_client cgi active_support).each{|lib| require lib}

$:.unshift File.dirname(__FILE__)
require 'springnote_client/base'

def Springnote(*params)
  Springnote::Note.new(*params)
end

module Springnote
  class Note
    attr_accessor :name, :config
    
    # config should have app_key, user_openid, user_key
    def initialize(name, config)
      @name, @config = name, config
    end
  
    def pages
      CallProxy.new(Page, self)
    end
        
    def username
      CGI.escape(@config[:user_openid] || 'anonymous')
    end
    
    def password
      @config[:user_key] ? "#{@config[:user_key]}.#{@config[:app_key]}" : @config[:app_key]
    end
    
    def url(path = '/', params = {})
      query = params.map{|k,v| "#{k}=#{CGI.escape(v.to_s)}"}.join('&')
      "http://api.springnote.com#{path}?domain=#{@name}&#{query}"
    end
  end
  

  class Page < Resource    
    def self.singular_name
      'page'
    end
    
    def self.collection_name
      'pages'
    end    
  end
end
