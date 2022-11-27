# frozen_string_literal: true

module RedmineCodeReviewPlus
  module AttachmentsHelperPatch
    # Dummy module for Zeitwerk mode.
  end
end

Rails.application.config.after_initialize do
  AttachmentsController.send(:helper, :issues)
  AttachmentsController.send(:helper, :queries)
end
