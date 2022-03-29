# frozen_string_literal: true

module RedmineCodeReviewPlus
  module AttachmentsHelperPatch
    include IssuesHelper
    include QueriesHelper
  end
end

AttachmentsHelper.include RedmineCodeReviewPlus::AttachmentsHelperPatch
