module ContextMenuRelations
  module Hooks
    class IssueHooks < Redmine::Hook::ViewListener
      # Remove protection, all requests are Ajax requests
      def protect_against_forgery?
        false
      end

      # Work around prompt to remote needing a url for the link_to and
      # that the javascript `promptToRemote` doesn't work with
      # existing url parameters
      def prompt_to_remote(name, text, param, url, html_options = {})
        html_options[:onclick] = "promptToRemoteWithOptions('#{text}', '#{param}', '#{url_for(url)}'); return false;"

        link_to name, url, html_options
      end

      # Add our own promptToRemoteWithOptions Javascript
      def view_layouts_base_html_head(context={})
        return javascript_tag(<<-EOJS
  function promptToRemoteWithOptions(text, param, url) {
    value = prompt(text + ':');
    if (value) {
      if (url.include('?')) {
        var finalUrl = url + '&' + param + '=' + encodeURIComponent(value);
      } else {
        var finalUrl = url + '?' + param + '=' + encodeURIComponent(value);
      }
      new Ajax.Request(finalUrl, {asynchronous:true, evalScripts:true});
      return false;
    }
  }
      EOJS
                              )
      end
      
      # * :issues
      # * :can
      # * :back
      def view_issues_context_menu_end(context={})
        relation_html = ''

        IssueRelation::TYPES.sort_by {|r| r[1][:order]}.each do |type|
          relation = type[0]
          options = type[1]
          relation_html << content_tag(:li, prompt_to_remote(l(options[:name]),
                                                             l(options[:name]),
                                                             'relation[issue_to_id',
                                                             {
                                                               :controller => 'issue_relations',
                                                               :action => 'new',
                                                               :issue_id => context[:issues].first.id,
                                                               :relation => {:relation_type => relation},
                                                               :back_to => context[:back]
                                                             }))
        end

        folder_html = content_tag(:a, l(:label_related_issues), :class => 'submenu') + content_tag(:ul, relation_html)
        return content_tag(:li, folder_html, :class => 'folder', :id => 'relations')
      end
    end
  end
end
