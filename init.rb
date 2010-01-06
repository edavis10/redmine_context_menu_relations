require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'

Dispatcher.to_prepare :redmine_context_menu_relations do
  require_dependency 'query'
  require_dependency 'queries_helper'
  
  unless QueriesHelper.included_modules.include? ContextMenuRelations::Patches::QueryPatch
    Query.send(:include, ContextMenuRelations::Patches::QueryPatch)
  end
  unless QueriesHelper.included_modules.include? ContextMenuRelations::Patches::QueryHelperPatch
    QueriesHelper.send(:include, ContextMenuRelations::Patches::QueryHelperPatch)
  end
end

require 'context_menu_relations/hooks/issue_hooks'

Redmine::Plugin.register :redmine_context_menu_relations do
  name 'Redmine Context Menu Relations plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'

  permission :relate_multiple_issues, { :multiple_issue_relations => [:new]}
end
