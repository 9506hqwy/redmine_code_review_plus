# frozen_string_literal: true

module RedmineCodeReviewPlus
  module IssuePatch
    def code_review_file_path
      code_review.file_path if code_review.present?
    end

    def code_review_line
      code_review.line if code_review.present?
    end
  end
end

Issue.prepend RedmineCodeReviewPlus::IssuePatch
