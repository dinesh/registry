
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
          if versioned? and create_version?
            create_initial_version
          end
        end

        def before_update
          super
          if versioned? and create_version?
            create_version
            update_version
          end
        end

        def before_destroy
          super
          if versioned? and create_version?
            create_destroyed_version
          end
        end

        def create_initial_version
          attributes = version_attributes.merge(:number => 1)
          add_version(Version.create(attributes))
          reset_version
        end

        def create_version?
          changed_columns.size > 0
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

        def changes_between(from, to)
          from_number, to_number = Version.number_at(from), Version.number_at(to)
          return {} if from_number == to_number
          backward = from_number > to_number

          chain = versions.select{|v| if backward
            v.number >= to_number && v.number <= from_number
          else
            v.number >= from_number && v.number <= to_number
          end }.reject(&:initial?)

          return {} if chain.empty?

          backward ? chain.pop : chain.shift unless from_number == 1 || to_number == 1

          chain.inject({}) do |changes, version|
            append_changes!(changes, backward ? reverse_changes(version.modifications) : version.modifications)
          end
        end

        def append_changes(hash, changes)
          changes.inject(hash) do |new_changes, (attribute, change)|
            new_change = [new_changes.fetch(attribute, change).first, change.last]
            new_changes.merge(attribute => new_change)
          end.reject do |attribute, change|
            change.first == change.last
          end
        end

        def append_changes!(hash, changes)
          hash.replace(append_changes(hash, changes))
        end

        def reverse_changes hash
          hash.inject({}){|nc,(a,c)| nc.merge!(a => c.reverse) }
        end

    end
end


Sequel::Model.class_eval { include Registry::HasVersions }