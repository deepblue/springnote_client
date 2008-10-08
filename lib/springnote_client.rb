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
    def initialize(name, config = {})
      @name, @config = name, config
    end
  
    def pages
      raise ConfigurationMissing unless @config[:app_key]
      CallProxy.new(Page, self)
    end
        
    def username
      CGI.escape(@config[:user_openid] || 'anonymous')
    end
    
    def password
      @config[:user_key] ? "#{@config[:user_key]}.#{@config[:app_key]}" : @config[:app_key]
    end
    
    def make_url(path = '/', params = {})
      query = params.map{|k,v| "#{k}=#{CGI.escape(v.to_s)}"}.join('&')
      "http://api.springnote.com#{path}?domain=#{@name}&#{query}"
    end
  end
  

  class Page < Resource    
    def self.singular_name;   'page'  end
    def self.collection_name; 'pages' end
    
    def attachments
      CallProxy.new(Attachment, self)
    end
    
    def make_url(path = '/', params = {})
      if self.hash
        holder.make_url("/pages/#{self.hash['identifier']}#{path}", params)
      else
        holder.make_url(path, params)        
      end
    end
  end
  
  class Attachment < Resource
    def self.singular_name;   'attachment'  end
    def self.collection_name; 'attachments' end    
  end
  
  def make_url(path = '/', params = {})
    holder.make_url(path, params)
  end
    
  class ConfigurationMissing < RuntimeError; end
end
