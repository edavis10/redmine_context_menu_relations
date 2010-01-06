require 'test_helper'

class ContextMenuRelations::Hooks::IssueHooksTest < ActionController::TestCase
  include Redmine::Hook::Helper
  def controller
    @controller ||= IssuesController.new
    @controller.response ||= ActionController::TestResponse.new
    @controller
  end

  def request
    @request ||= ActionController::TestRequest.new
  end
  
  def hook(args={})
    call_hook :view_issues_context_menu_end, args
  end

  context "#view_issues_context_menu_end" do
    setup do
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project)
      @can = {}
      @back = 'http://example.com/back'
    end

    context "with one issue" do
      should "render the relations 'folder'" do
        @response.body = hook(:issues => [@issue], :can => @can, :back => @back)

        assert_select "li.folder#relations"
      end
      
      should "render the option for the relates to relation" do
        @response.body = hook(:issues => [@issue], :can => @can, :back => @back)

        assert_select "a[href*=?]", "/issues/#{@issue.id}/relations", :text => /related to/i
      end

      should "render the option for the duplicates relation" do
        @response.body = hook(:issues => [@issue], :can => @can, :back => @back)

        assert_select "a[href*=?]", "/issues/#{@issue.id}/relations", :text => /duplicates/i
      end

      should "render the option for the blocks relation" do
        @response.body = hook(:issues => [@issue], :can => @can, :back => @back)

        assert_select "a[href*=?]", "/issues/#{@issue.id}/relations", :text => /blocks/i
      end

      should "render the option for the precedes" do
        @response.body = hook(:issues => [@issue], :can => @can, :back => @back)

        assert_select "a[href*=?]", "/issues/#{@issue.id}/relations", :text => /precedes/i
      end

      should "render the prompt so the user can enter the target issue id" do
        @response.body = hook(:issues => [@issue], :can => @can, :back => @back)

        assert_select "a[onclick*=?]", /promptToRemoteWithOptions/i
      end
    end
  end
end
