




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
      visit @link
      sleep(2)
    end
    
    def parse
      parsed_file = FasterCSV.read('/Users/krishnarokhale/downloads/graphic-links.csv')
      parsed_file.delete_at(0)
      init_data(parsed_file)
      File.delete('/Users/krishnarokhale/downloads/graphic-links.csv')
    end
    
    def init_data(parsed_file)
      parsed_file.each do |row|
        @data << {:date_added => row[0], :dimensions => row[1], :image_url => row[5], :endpoint => row[5]}
      end
    end
    
  end
  
end