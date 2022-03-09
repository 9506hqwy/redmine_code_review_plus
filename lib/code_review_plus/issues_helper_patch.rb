# frozen_string_literal: true

module RedmineCodeReviewPlus
  module IssuesHelperPatch
    include RedmineCodeReviewPlus::Helper
  end
end

IssuesHelper.include RedmineCodeReviewPlus::IssuesHelperPatch
