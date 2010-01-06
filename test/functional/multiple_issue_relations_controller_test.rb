require 'test_helper'

class MultipleIssueRelationsControllerTest < ActionController::TestCase
   fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :issue_relations,
           :enabled_modules,
           :enumerations,
           :trackers

  def setup
    @controller = MultipleIssueRelationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil

    @user = User.generate_with_protected!(:admin => true)
    User.current = @user
    assert User.current.admin?
      
    @project = Project.generate!
    @issue = Issue.generate_for_project!(@project)
    @related_issues = [
                       Issue.generate_for_project!(@project),
                       Issue.generate_for_project!(@project),
                       Issue.generate_for_project!(@project)
                      ]
                          
  end

  context "POST :new" do
    should "create an issue relation to the target issue for each visible issue" do
      assert_difference 'IssueRelation.count',3 do
        @request.session[:user_id] = @user.id
        post(:new, :issue_ids => @related_issues.collect(&:id),
             :relation => {:issue_to_id => @issue.id, :relation_type => 'relates', :delay => ''})
      end

      @related_issues.each do |related_issue|
        related_issue.reload
        assert related_issue.relations_from.collect(&:issue_to).include?(@issue)
      end
    end
  end
end
