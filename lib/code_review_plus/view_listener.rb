# frozen_string_literal: true

module RedmineCodeReviewPlus
  class ViewListener < Redmine::Hook::ViewListener
    render_on :view_layouts_base_html_head, partial: 'code_review_plus/html_head'
    render_on :view_layouts_base_body_bottom, partial: 'code_review_plus/body_bottom'
  end
end
