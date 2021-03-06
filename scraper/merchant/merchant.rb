


module Import
  
  class Merchant
    
    attr_reader :links, :id
    
    def initialize(links)
      @id ||= links.keys.first.to_i
      @links ||= links.values.flatten.collect {|link| Link.new({@id => link})}
      puts "Merchant id: #{@id} processed!"
    end
    
  end
  
end