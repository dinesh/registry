
Sequel.connect(Registry::Config.database_url)

migration "create companies" do
    database.create_table :companies do
        primary_key :id
        string      :name, unique: true, null: false
        string      :email
        text        :address
        string      :city
        string      :country
        string      :phone
        timestamp   :stamp
    end

    database.create_table :owners do
        primary_key :id
        integer :company_id
        string :name, null: false
        timestamp :stamp
        string :passport_content_type
        string :passport_file_name
    end
end