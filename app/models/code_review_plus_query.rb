# frozen_string_literal: true

class CodeReviewPlusQuery < IssueQuery
  self.available_columns = IssueQuery.available_columns +
    [
      QueryColumn.new(:code_review_file_path,
                      sortable: "#{CodeReview.table_name}.file_path",
                      caption: :label_code_review_file_path),
      QueryColumn.new(:code_review_line,
                      sortable: "#{CodeReview.table_name}.line",
                      caption: :label_code_review_line),
    ]

  def initialize(attributes=nil, *args)
    super
    self.filters = {}
  end

  def joins_for_order_statement(order_options)
    joins = [super]

    if order_options &&
        (order_options.include?("#{CodeReview.table_name}.file_path") ||
         order_options.include?("#{CodeReview.table_name}.line"))
      joins <<
        "LEFT OUTER JOIN #{CodeReview.table_name} " \
        " ON #{CodeReview.table_name}.issue_id = #{queried_table_name}.id"
    end

    joins.any? ? joins.join(' ') : nil
  end
end
