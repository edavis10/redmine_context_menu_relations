require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'

Dispatcher.to_prepare :redmine_context_menu_relations do
end

require 'context_menu_relations/hooks/issue_hooks'

Redmine::Plugin.register :redmine_context_menu_relations do
  name 'Redmine Context Menu Relations plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end
