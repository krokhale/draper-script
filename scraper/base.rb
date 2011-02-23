require 'capybara'
require 'capybara/dsl'



module Import
  
  class Scraper
    include Capybara
        
    def initialize
      Capybara.current_driver = :selenium
      Capybara.run_server = false
    end
    
    def scrape!
      visit "http://buy.at"
      fill_in 'email', :with => "pizzaboy@pizzapowered.com"
      fill_in 'password', :with => "pizzaboy"
      click_button 'login'
      visit "https://users.buy.at/ma/index.php/affiliateProgrammes/programmes?&format=csv"
    end    

    
  end
  
end

importer = Import::Scraper.new
importer.scrape!