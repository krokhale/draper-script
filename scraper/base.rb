require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'merchant/merchant'
require 'merchant/link'
require 'fastercsv'
require 'hpricot'


module Import
  
  PROGRAMMES_PATH = '/Users/krishnarokhale/downloads/programmes.csv'
  LINKS_PATH = '/Users/krishnarokhale/downloads/graphic-links.csv' 
  
  def self.init
   Capybara.register_driver :selenium do |app|
      Capybara::Driver::Selenium.new(app, :browser => :chrome)
    end
    Capybara.current_driver = :selenium
    Capybara.run_server = false
  end
  
  class Scraper
    include Capybara
    
    attr_reader :merchants
        
    def initialize   
     Import.init
    end
    
    def scrape!
      visit "http://buy.at"
      fill_in 'email', :with => "pizzaboy@pizzapowered.com"
      fill_in 'password', :with => "pizzaboy"
      click_button 'login'
      sleep(5)
      visit "https://users.buy.at/ma/index.php/affiliateProgrammes/programmes?&format=csv"
      sleep(5)
      driver
    end
    
    
    
    protected
    
    def driver
      merchant_ids = parse
      links = generate_links(merchant_ids)
      @merchants = init_merchants(links)
      File.delete(PROGRAMMES_PATH)
    end 
    
    def parse
      parsed_file = FasterCSV.read(PROGRAMMES_PATH)
      parsed_file.delete_at(0)
      merchant_ids = parsed_file.collect {|row| row[11]}.uniq
      return merchant_ids
    end 
    
    def generate_links(ids)
      links = []
      ids.each do |id|
        links << {id => ["https://users.buy.at/ma/index.php/affiliateCreative/creativeGraphics/prog_id/#{id}/creative_type_id/1/creativegroup/0/dimension/0/perpage/-1&format=csv", "https://users.buy.at/ma/index.php/affiliateCreative/creativeGraphics/prog_id/#{id}/creative_type_id/6/creativegroup/0/dimension/0/perpage/-1&format=csv", "https://users.buy.at/ma/index.php/affiliateCreative/creativeGraphics/prog_id/#{id}/creative_type_id/2/creativegroup/0/dimension/0/perpage/-1&format=csv"]}
      end
      return links
    end  
    
    def init_merchants(links)
      return links.collect {|link| Merchant.new(link)}
    end

    
  end
  
end

#importer = Import::Scraper.new
#importer.scrape!