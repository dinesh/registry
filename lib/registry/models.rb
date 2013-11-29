module Registry

  class Company < Sequel::Model
    has_versioning ## enable versioning
    plugin :validation_helpers
    set_primary_key :id
    one_to_many :owners

    def validate
        validates_presence [:name, :address, :city, :country, :phone]
        if email
            validates_format /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :email
        end
    end
  end

  class Owner < Sequel::Model
    has_versioning ## enable versioning
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

  class Version < Sequel::Model
    plugin :serialization
    plugin :dirty
    serialize_attributes :marshal, :modifications

    def self.number_at(value)
      case value
        when Date, Time then (v = at(value)) ? v.number : 1
        when Numeric then value.floor
        when String, Symbol then (v = at(value)) ? v.number : nil
        when Version then value.number
      end
    end

    def initial?
        number == 1
    end

  end

end