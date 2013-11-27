
Sequel.migration do
    up do
        create_table! :companies do
            primary_key :id
            String      :name, unique: true, null: false
            String      :email
            text        :address
            String      :city
            String      :country
            String      :phone
            timestamp   :stamp
        end
    end

    down do
        drop_table :companies
    end

end