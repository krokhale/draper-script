




module Import
  
  class Link
    include Capybara
    
    attr_reader :merchant_id, :data
    
    def initialize(link)
      Import.init
      @link ||= link.values.first
      @merchant_id ||= link.keys.first.to_i
      @data ||= []
      scrap
      parse
    end
    
    protected
    
    def scrap
      puts "visiting link::: #{@link}"
      visit @link
      sleep(1)
    end
    
    def parse
      if File.exists?(LINKS_PATH)
      parsed_file = FasterCSV.read(LINKS_PATH)
      parsed_file.delete_at(0)
      init_data(parsed_file)
      File.delete(LINKS_PATH)
      end
    end
    
    def init_data(parsed_file)
      parsed_file.each do |row|
        doc = Hpricot(row[5])
        endpoint = (doc/"a").first.attributes.to_hash.values.first unless (doc/"a").first.nil?
        image_url = (doc/"img").first.attributes.to_hash.values.first unless (doc/"img").first.nil?
        @data << {:date_added => row[0], :dimensions => row[1], :image_url => image_url, :endpoint => endpoint}
      end
    end
    
  end
  
end