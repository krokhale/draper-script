class DraperProductImporter
  
  def initialize(path)
    parsed_file = FasterCSV.read(path)
    @headers ||= parsed_file.delete_at(0)
    @data ||= parsed_file
  end
  
  def import!
    @data.each do |row|
      product_exists?(row) ? update_records(row) : create_records(row)
    end
  end
  
  
  private
  
  def product_exists?(row)
    product = Product.find_by_code(row[0])
  end
  
  def update_records(row)
    master_variant = Variant.find_by_code(row[0])
    populate_record(master_variant,row) if master_variant
  end
  
  def create_records(row)
    product = Product.create(:code => row[0], :title => row[22])
    master_variant = Variant.create(:product_id => product.id, :code => row[0])
    
    [product,master_variant].each do |record|
      populate_record(record,row)
    end
  end
  
  def populate_record(record,row)
    if record.is_a? Product
      record.update_attributes("coupon_image_file_size"=>nil, "coupon_image_content_type"=>nil, "comes_with"=>nil, "colour_options"=>nil,
       "available_from"=>nil, "dvd_description"=>nil, "delivery_price_in_pennies"=>nil, "coupon_image_updated_at"=>nil,
        "imported_at"=> Time.now, "benefit"=>nil, "tax_code"=> row[13], "buying_price_in_pennies"=>nil,
         "minimum_order_quantity"=>"0", "meta_keywords"=>"", "meta_description"=> row[1], "client_id"=>nil, "supplier_id"=>nil,
          "web_description"=>nil, "import_reference"=> row[5], "height_options"=>nil, "description"=> row[23], "contents"=> row[24],
           "classification"=>nil, "carriage_terms"=>nil, "buying_price"=>nil, "specifications"=> row[25], "dealer_discount_code"=> row[32],
            "shipping_code"=>nil, "print_description"=>nil, "coupon_image_file_name"=>nil, "brand_id"=>nil, "available_until"=>nil)
    else
      record.update_attributes("position"=>1, "delivery_time"=>nil, "delivery_price_in_pennies"=>nil,
        "price_breaks"=>nil, "imported_at"=> Time.now, "height_option"=>nil, "minimum_order_quantity"=>nil,
        "extra_delivery_price_in_pennies"=>nil, "price_in_pennies"=> row[4]*100, "import_reference"=> row[5], "colour_option"=>nil,
         "carriage_terms"=>nil, "to_be_removed_description"=>nil, "available_until"=>nil)
    end
    record.save!
    puts "#{record.class.to_s} , id: #{record.id} extracted and saved!"
  end
  
end
    