# frozen_string_literal: true

module RedmineCodeReviewPlus
  module Helper
    def show_code_comment_at(review, context=3, format='text', &block)
      if review.attachment.present?
        Utils.show_attachment_fragment(review, context, format, &block)
      end
    end
  end
end
