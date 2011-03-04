




module Import
  
  class Link
    
    attr_reader :merchant_id, :date_added, :dimensions, :image_url, :endpoint
    
    def initialize(link)
      @link ||= link.values.first
      @merchant_id ||= link.keys.first.to_i
      parse
    end
    
    protected
    
    def parse
      
    end
    
  end
  
end