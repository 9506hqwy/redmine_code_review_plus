# frozen_string_literal: true

basedir = File.expand_path('../lib', __FILE__)
libraries =
  [
    'redmine_code_review_plus/helper',
    # require helper module before other.
    'redmine_code_review_plus/application_helper_patch',
    'redmine_code_review_plus/attachments_helper_patch',
    'redmine_code_review_plus/issue_patch',
    'redmine_code_review_plus/utils',
    'redmine_code_review_plus/view_listener',
  ]

libraries.each do |library|
  require_dependency File.expand_path(library, basedir)
end

Redmine::Plugin.register :redmine_code_review_plus do
  name 'Redmine Code Review Plus plugin'
  author '9506hqwy'
  description 'This is a extension plugin for the code review plugin for Redmine'
  version '0.3.0'
  url 'https://github.com/9506hqwy/redmine_code_review_plus'
  author_url 'https://github.com/9506hqwy'

  requires_redmine_plugin :redmine_code_review, version_or_higher: '0.9.0'
end
