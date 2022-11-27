# frozen_string_literal: true

Rails.application.config.after_initialize do
  AttachmentsController.send(:helper, :issues)
  AttachmentsController.send(:helper, :queries)
end
