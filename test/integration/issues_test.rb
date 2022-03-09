# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class IssuesTest < Redmine::IntegrationTest
  include Redmine::I18n

  fixtures :attachments,
           :enabled_modules,
           :enumerations,
           :issue_statuses,
           :issues,
           :journal_details,
           :journals,
           :member_roles,
           :members,
           :projects,
           :projects_trackers,
           :roles,
           :trackers,
           :users,
           :versions

  def setup
    set_fixtures_attachments_directory
  end

  def teardown
    set_tmp_attachments_directory
  end

  def test_show_no_code_review
    log_user('admin', 'admin')

    get('/issues/1')

    assert_response :success
  end

  def test_show_code_review_attachment_text
    attachment = attachments(:attachments_004)
    issue = attachment.container

    c = CodeReview.new
    c.project_id = issue.project_id
    c.line = 1
    c.updated_by_id = 1
    c.issue_id = issue.id
    c.action_type = 'attachment'
    c.file_path = 'undefined'
    c.attachment_id = attachment.id
    c.file_count = 0
    c.diff_all = true
    c.save!

    log_user('admin', 'admin')

    get("/issues/#{issue.id}")

    assert_response :success
  end

  def test_show_code_review_attachment_diff
    attachment = attachments(:attachments_005)
    issue = attachment.container

    c = CodeReview.new
    c.project_id = issue.project_id
    c.line = 152
    c.updated_by_id = 1
    c.issue_id = issue.id
    c.action_type = 'attachment'
    c.file_path = 'trunk/app/controllers/issues_controller.rb'
    c.attachment_id = attachment.id
    c.file_count = 0
    c.diff_all = true
    c.save!

    log_user('admin', 'admin')

    get("/issues/#{issue.id}")

    assert_response :success
  end
end
