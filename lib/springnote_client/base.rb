module RestClient
	class Resource
		attr_accessor :url
	end
end


module Springnote
  class CallProxy
    def initialize(callee, *params)
      @callee, @params = callee, params
    end
    
    def method_missing(method, *params, &block)
      @callee.send(method, *(params + @params), &block)
    end
  end
  
  class Resource < RestClient::Resource
    XML = 'application/xml'
    attr_accessor :hash, :holder
    
    class << self
      def build(hsh, holder)
        new_resource(collection_url(holder), holder, hsh)
      end
            
      def new_resource(url, holder, hash = nil)
        ret = new(url, holder.username, holder.password)
        ret.holder = holder
        
        if block_given?
          ret.hash = yield(ret)
        elsif hash
          identifier = hash.delete('identifier')
          ret.hash = hash
          ret.identifier = identifier if identifier
        end

        ret
      end
      
      def element_url(holder, id, params = {})
        holder.make_url("/#{collection_name}/#{id}", params)
      end

      def collection_url(holder, params = {})
        holder.make_url("/#{collection_name}", params)
      end      
      
      def find(*args)
        holder = args.pop

        args.length == 1 ? 
          find_one(args[0], holder) : 
          find_some(args, holder)
      end
      
      def find_one(id, holder)
        new_resource(element_url(holder, id), holder) do |ret| 
          Hash.from_xml(ret.get(:accept => XML))[ret.singular_name]
        end
      end
      
      def find_all(holder)
        find_multi(holder)
      end

      def find_some(ids, holder)
        find_multi(holder, :identifiers => ids.join(','), :detail => true)
      end
      
      def find_multi(holder, params = {})
        target = collection_url(holder, params)
        ret = new_resource(target, holder).get(:accept => 'application/xml')

        Hash.from_xml(ret)[collection_name].map do |item|
          new_resource(element_url(holder, item['identifier']), holder, item)
        end
      rescue RuntimeError
        []  
      end
      
      def search(query, holder)
        find_multi(holder, :q => query)
      end
    end 

    def method_missing(method, *args)
      str = method.to_s
      (str[-1].to_s == "=") ?
        @hash[str[0..-2]] = args[0] : 
        @hash[str]
    end
    
    def save
      xml = @hash.to_xml(:root => singular_name)
      
      if @hash['identifier']
        put xml, :content_type => XML
      else
        ret = post(xml, :content_type => XML)
        @hash = Hash.from_xml(ret)[singular_name]
        self.url = element_url
      end
      
      self
    end
    
    def delete
      super
      self.identifier = nil
    end
    
    def identifier=(newval)
      @hash['identifier'] = newval
      self.url = element_url
      newval
    end
    
    def element_url
      self.class.element_url(holder, @hash['identifier'])
    end
    
    def singular_name
      self.class.singular_name
    end
    
    def inspect
      @hash.inspect
    end
    
    def to_s
      @hash.to_s
    end
  end
end