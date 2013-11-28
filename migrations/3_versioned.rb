
Sequel.migration do
    up do
        create_table! :versions do
            primary_key :id
            varchar :versioned_type
            integer :versioned_id
            varchar :username
            text :modifications
            integer :number
            integer :revered_from
            varchar :tag
        end
    end

    down do
        drop_table :versions
    end

end
