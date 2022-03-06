# frozen_string_literal: true

module RedmineCodeReviewPlus
  module AttachmentsHelper
    include IssuesHelper
    include QueriesHelper
  end
end

AttachmentsHelper.include RedmineCodeReviewPlus::AttachmentsHelper
