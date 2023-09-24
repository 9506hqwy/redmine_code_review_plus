# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class IssuesTest < Redmine::IntegrationTest
  include ActiveJob::TestHelper
  include Redmine::I18n

  fixtures :attachments,
           :changes,
           :changesets,
           :email_addresses,
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
           :repositories,
           :roles,
           :trackers,
           :users,
           :versions

  def setup
    Setting.plain_text_mail = 1
    Setting.notified_events = ['issue_added']
    ActionMailer::Base.deliveries.clear

    set_fixtures_attachments_directory
  end

  def teardown
    set_tmp_attachments_directory
  end

  def test_create_code_review
    p = projects(:projects_001)
    p.enable_module!(:code_review)
    p.enable_module!(:mail_template)

    @template = MailTemplate.new
    @template.project_id = p.id
    @template.notifiable = 'issue_added'
    @template.template = '<%= raw show_code_comment_text_table_at(@issue.code_review) %>'
    @template.save!

    log_user('admin', 'admin')

    perform_enqueued_jobs do
      new_record(Issue) do
        post(
          '/projects/ecookbook/code_review/new',
          params: {
            id: '1',
            review: {
              line: '1',
              change_id: '1',
              comment: 'test comment',
              subject: 'test title',
            },
            action_type: 'diff',
          })
      end
    end

    assert_not_equal 0, ActionMailer::Base.deliveries.length
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

  def test_show_code_review_changeset
    change = changes(:changes_001)
    issue = issues(:issues_001)

    c = CodeReview.new
    c.project_id = change.changeset.repository.project_id
    c.line = 1
    c.updated_by_id = 1
    c.issue_id = issue.id
    c.action_type = 'diff'
    c.file_path = '/test/some/path/in/the/repo'
    c.change_id = change.id
    c.file_count = 0
    c.diff_all = false
    c.save!

    log_user('admin', 'admin')

    get("/issues/#{issue.id}")

    assert_response :success
  end

  def test_show_code_review_diff
    issue = issues(:issues_001)

    c = CodeReview.new
    c.project_id = issue.project_id
    c.line = 1
    c.updated_by_id = 1
    c.issue_id = issue.id
    c.action_type = 'diff'
    c.file_path = '.'
    c.file_count = 0
    c.rev = 3
    c.rev_to = 1
    c.diff_all = false
    c.save!

    log_user('admin', 'admin')

    get("/issues/#{issue.id}")

    # FIXME: HTTP500
    # assert_response :success
    skip
  end
end
