require 'test_helper'

class QueriesHelperTest < HelperTestCase
  include ActionView::Helpers::TextHelper
  include ApplicationHelper
  include QueriesHelper

  context "column_content with the :formatted_relations column" do
    setup do
      @user = User.generate_with_protected!(:admin => true)
      User.current = @user
      assert User.current.admin?
      
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project)
      @column = QueryColumn.new(:formatted_relations)
    end
    
    context "for an issue with no relations" do
      should "return nothing" do
        assert_equal '', column_content(@column, @issue)
      end
    end

    context "for an issue with relations" do
      setup do
        @related = Issue.generate_for_project!(@project)
        IssueRelation.generate!(:issue_from => @related, :issue_to => @issue, :relation_type => IssueRelation::TYPE_RELATES)
      end

      should "return a list of the relations" do
        response = column_content(@column, @issue)

        assert response.include?('<ul')
        assert response.include?('<li')
      end

      should "show the relation type" do
        response = column_content(@column, @issue)

        assert response.include?(l(:label_relates_to))
      end

      should "link to the related issue" do
        response = column_content(@column, @issue)

        assert response.include?('/issues/2')
      end

    end
  end
end
