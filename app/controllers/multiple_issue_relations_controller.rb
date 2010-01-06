class MultipleIssueRelationsController < ApplicationController
  unloadable
  before_filter :find_project, :authorize

  def new
    if params[:relation] && params[:issue_ids]
      @saved = 0
      @issue_failed = []
      params[:issue_ids].each do |issue_id|

        @relation = IssueRelation.new(params[:relation])
        @relation.issue_from = Issue.visible.find_by_id(issue_id)
        if params[:relation] && !params[:relation][:issue_to_id].blank?
          @relation.issue_to = Issue.visible.find_by_id(params[:relation][:issue_to_id])
        end

        if request.post? && !@relation.save
          @issue_failed << @relation.issue_from_id
        end
      end

      if @issue_failed.empty?
        flash[:notice] = l(:notice_successful_update)
      else
        flash[:error] = l(:notice_failed_to_save_issues, :count => @issue_failed.size,
                          :total => @issue_failed.size,
                          :ids => '#' + @issue_failed.join(', #'))
      end
    end

    redirect_url = params[:back_to] || {:controller => 'issues', :action => 'index', :project_id => @project}
    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.js do
        render :update do |page|
          page.redirect_to(redirect_url)
        end
      end
    end
  end

  private
  def find_project
    if params[:relation] && params[:relation][:issue_to_id]
      @issue = Issue.find(params[:relation][:issue_to_id])
      @project = @issue.project
    else
      render_404
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
