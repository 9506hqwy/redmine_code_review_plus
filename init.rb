# frozen_string_literal: true

require_dependency 'code_review_plus/helper'
# require helper module before other.
require_dependency 'code_review_plus/application_helper_patch'
require_dependency 'code_review_plus/attachments_helper_patch'
require_dependency 'code_review_plus/issue_patch'
require_dependency 'code_review_plus/utils'
require_dependency 'code_review_plus/view_listener'

Redmine::Plugin.register :redmine_code_review_plus do
  name 'Redmine Code Review Plus plugin'
  author '9506hqwy'
  description 'This is a extension plugin for the code review plugin for Redmine'
  version '0.2.0'
  url 'https://github.com/9506hqwy/redmine_code_review_plus'
  author_url 'https://github.com/9506hqwy'

  requires_redmine_plugin :redmine_code_review, version_or_higher: '0.9.0'
end
