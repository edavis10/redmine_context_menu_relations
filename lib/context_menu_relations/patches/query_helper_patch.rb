module ContextMenuRelations
  module Patches
    module QueryHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method_chain :column_content, :formatted_relations
        end
      end
      
      module InstanceMethods
        def column_content_with_formatted_relations(column, issue)
          if column.name == :formatted_relations
            return formatted_relations(issue)
          else
            return column_content_without_formatted_relations(column, issue)
          end
        end
        
        def formatted_relations(issue)
          relations = issue.relations.select {|r| r.other_issue(issue).visible?}
          return '' if relations.empty?
          html = '<ul>'
          relations.each do |relation|
            html << "<li style='text-align:left'>"
            html << l(relation.label_for(issue))
            html << ' '
            html << link_to_issue(relation.other_issue(issue), :subject => false)
            html << "</li>"
          end
          html << '</ul>'
          return html
        end
      end
    end


  end
end
