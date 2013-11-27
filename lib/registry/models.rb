

module Registry

  class Company < Sequel::Model
    plugin :validation_helpers
    set_primary_key :id

    one_to_many :employees
    one_to_one :director

    def validate
        validates_presence [:name, :address, :city, :country, :phone]
        if email
            validates_format /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :email
        end
    end
  end


  class Owner < Sequel::Model
    plugin :validation_helpers
    set_primary_key :id
    many_to_one :company

    def validate
        validates_presence [:name]
        if passport_file_name
            validates_presence [:passport_content_type]
            validates_includes ['image/png', 'image/jpeg', 'image/jpg'], :passport_content_type
        end
    end
  end

end