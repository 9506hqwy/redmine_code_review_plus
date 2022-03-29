# frozen_string_literal: true

module RedmineCodeReviewPlus
  module ApplicationHelperPatch
    include RedmineCodeReviewPlus::Helper
  end
end

ApplicationHelper.include RedmineCodeReviewPlus::ApplicationHelperPatch
