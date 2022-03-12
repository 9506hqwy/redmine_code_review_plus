# frozen_string_literal: true

module RedmineCodeReviewPlus
  module Helper
    def show_code_comment_at(review, context=3, format='text', &block)
      if review.attachment.present?
        Utils.show_attachment_fragment(review, context, format, &block)
      elsif review.change.present?
        Utils.show_changeset_fragment(review, context, format, &block)
      elsif review.rev.present? && review.rev_to.present?
        review.project.repositories.each do |repository|
          changeset = repository.changesets.find_by(revision: review.rev)
          if changeset
            diff = repository.diff(review.path, review.rev, review.rev_to)
            files = Redmine::UnifiedDiff.new(diff, style: repository.class.scm_name)
            if review.file_count < files.length
              file_path = files[review.file_count].file_name
              Utils.show_revision_fragment(repository, file_path, review, context, format, &block)
            end

            break
          end
        end
      end
    end
  end
end
