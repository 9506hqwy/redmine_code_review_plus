#!/bin/bash
set -euo pipefail

CODE_REVIEW="https://github.com/9506hqwy/redmine_code_review.git"
MAIL_TEMPLATE="https://github.com/9506hqwy/redmine_mail_template.git"

CODE_REVIEW_BRANCH="develop60"
if [[ ! "${REDMINE_VERSION}" =~ ^6\. ]]; then
    CODE_REVIEW_BRANCH="develop51"
fi

git clone --depth 1 --branch "${CODE_REVIEW_BRANCH}" "${CODE_REVIEW}"
git clone --depth 1 "${MAIL_TEMPLATE}"
