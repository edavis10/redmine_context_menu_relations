# Patches Redmine's Queries dynamically, adding the Relations to the
# available query columns
module ContextMenuRelations
  module Patches
    module QueryPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          base.add_available_column(QueryColumn.new(:formatted_relations))
        end

      end
      
      module ClassMethods
        
        # Setter for +available_columns+ that isn't provided by the core.
        def available_columns=(v)
          self.available_columns = (v)
        end

        # Method to add a column to the +available_columns+ that isn't provided by the core.
        def add_available_column(column)
          self.available_columns << (column)
        end
      end
      
      module InstanceMethods
      end
    end

  end
end
