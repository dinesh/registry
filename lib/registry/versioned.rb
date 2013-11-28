
module Registry
    module HasVersions
        def self.included(base)
            base.extend(ClassMethods)
        end

        module ClassMethods
            def has_versioning options = {}
                class << self
                  def versioned? ; true; end
                end

                class_eval do
                    plugin :dirty
                    plugin :polymorphic
                    has_many :versions, :as => :versioned
                end
            end

          def versioned?
            false
          end

        end ## ClassMethods

        def versioned?; self.class.versioned?; end

        def after_create
          super
          create_initial_version if versioned?
        end

        def after_update
          super
          create_version if versioned?
          update_version if versioned?
        end

        def before_destroy
          super
          create_destroyed_version if versioned?
        end

        def create_initial_version
          attributes = version_attributes.merge(:number => 1)
          add_version(Version.create(attributes))
          reset_version
        end

        def create_version?
          !changed_columns.blank?
        end

        # Creates a new version upon updating the parent record.
        def create_version(attributes = nil)
          add_version(Version.create(attributes || version_attributes))
          reset_version
        end

        def update_version
           return create_version unless v = versions.last
           v.will_change_column(:modifications)
           v.update(:modifications => version_attributes[:modifications])
           reset_version
        end


        def create_destroyed_version
          create_version({:modifications => column_changes, :number => last_version + 1, :tag => 'deleted'})
        end

        def last_version
          @last_version ||= versions.map(&:number).max || 1
        end

        def version
          @version ||= last_version
        end

        def reset_version(version = nil)
          if version.nil?
            @last_version = nil
            @reverted_from = nil
          else
            @reverted_from = version
          end
          @version = version
        end

        def version_attributes
          { :modifications => column_changes, :number => last_version + 1}
        end

    end
end


Sequel::Model.class_eval { include Registry::HasVersions }