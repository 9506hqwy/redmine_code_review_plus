# frozen_string_literal: true

module RedmineCodeReviewPlus
  module Utils
    def self.delete_revision(name)
      name.sub(/\s*\(.+\)\s*$/, '')
    end

    def self.get_html(file_name, contents, lstart, marked_line, &block)
      content = contents.join("\n")

      ret = []

      line_num = lstart
      Redmine::SyntaxHighlighting.highlight_by_filename(content, file_name).each_line do |line|
        if block
          yield line_num, line, line_num == marked_line
        else
          ret << [line_num, line, line_num == marked_line]
        end

        line_num += 1
      end

      unless block
        ret
      end
    end

    def self.get_text(contents, lstart, marked_line, &block)
      ret = []

      line_num = lstart
      contents.each do |line|
        if block
          yield line_num, line, line_num == marked_line
        else
          ret << [line_num, line, line_num == marked_line]
        end

        line_num += 1
      end

      unless block
        ret
      end
    end

    def self.show_attachment_fragment(review, context, format, &block)
      content = File.read(review.attachment.diskfile, mode: 'rb')

      if review.attachment.is_diff?
        show_diff_fragment(review.file_path, content, review.line, context, format, &block)
      else
        contents = split_content(content)
        show_file_fragment(review.attachment.filename, contents, review.line, context, format, &block)
      end
    end

    def self.show_changeset_fragment(review, context, format, &block)
      content = review.repository.cat(review.path, review.revision)
      contents = split_content(content)
      show_file_fragment(review.path, contents, review.line, context, format, &block)
    end

    def self.show_diff_fragment(path, content, marked_line, context, format, &block)
      path = delete_revision(path.chomp)

      diffs = Redmine::UnifiedDiff.new(content)
      diff = diffs.find { |d| delete_revision(d.file_name.chomp) == path }

      if diff.nil?
        raise "Not found '#{path}'."
      end

      first = diff.find { |d| d.nb_line_right.present? }
      if first
        lstart = marked_line - context
        lstart = first.nb_line_right.to_i if lstart < first.nb_line_right.to_i

        lend = marked_line + context

        targets = []
        diff.each do |d|
          if d.nb_line_right.present? &&
              lstart <= d.nb_line_right.to_i &&
              d.nb_line_right.to_i <= lend
            targets << d.line_right
          end
        end

        if format == 'html'
          get_html(path, targets, lstart, marked_line, &block)
        else
          get_text(targets, lstart, marked_line, &block)
        end
      end
    end

    def self.show_file_fragment(file_name, contents, marked_line, context, format, &block)
      lstart = marked_line - context
      lstart = 1 if lstart < 1

      lend = marked_line + context
      lend = contents.length if lend > contents.length

      targets = contents[lstart-1..lend-1]

      if format == 'html'
        get_html(file_name, targets, lstart, marked_line, &block)
      else
        get_text(targets, lstart, marked_line, &block)
      end
    end

    def self.show_revision_fragment(repository, path, review, context, format, &block)
      path = delete_revision(path)
      content = repository.cat(path, review.revision)
      contents = split_content(content)
      show_file_fragment(path, contents, review.line, context, format, &block)
    end

    def self.split_content(content)
      content ||= ''
      content
        .split("\n")
        .map { |c| to_utf8(c.chomp) }
    end

    def self.to_utf8(text)
      Redmine::CodesetUtil.to_utf8_by_setting(text)
    end
  end
end
