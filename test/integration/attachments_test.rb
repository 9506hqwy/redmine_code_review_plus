# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class DocumentsTest < Redmine::IntegrationTest
  include Redmine::I18n

  fixtures :attachments,
           :enabled_modules,
           :enumerations,
           :issues,
           :member_roles,
           :members,
           :projects,
           :projects_trackers,
           :roles,
           :trackers,
           :users

  def setup
    set_fixtures_attachments_directory
  end

  def teardown
    set_tmp_attachments_directory
  end

  def test_show
    log_user('admin', 'admin')

    get('/attachments/4')

    assert_response :success
  end
end
