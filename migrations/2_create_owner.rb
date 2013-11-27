

Sequel.migration do
    up do
        create_table! :owners do
            primary_key :id
            integer :company_id
            String :name, null: false
            timestamp :stamp
            String :passport_content_type
            String :passport_file_name
        end
    end

    down do
        drop_table :owners
    end
end