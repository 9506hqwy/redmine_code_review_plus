#!/bin/bash
set -euo pipefail

REDMINE_URL=https://github.com/redmine/redmine.git
CODE_REVIEW_URL=https://github.com/9506hqwy/redmine_code_review.git
MAIL_TEMPLATE_URL=https://github.com/9506hqwy/redmine_mail_template.git

sudo apt update
sudo apt install -y imagemagick

sudo mkdir "${REDMINE_HOME}"
sudo chmod 777 "${REDMINE_HOME}"

pushd "${REDMINE_HOME}"

git clone --depth 1 -b 5.0-stable "${REDMINE_URL}" 5.0
git clone --depth 1 -b 5.1-stable "${REDMINE_URL}" 5.1
git clone --depth 1 -b 6.0-stable "${REDMINE_URL}" 6.0

for BASE in $(ls)
do
    pushd "${BASE}"

    cat >config/database.yml <<EOF
production:
  adapter: sqlite3
  database: db/redmine.sqlite

development:
  adapter: sqlite3
  database: db/redmine_dev.sqlite

test:
  adapter: sqlite3
  database: db/redmine_test.sqlite3
EOF

    echo "gem 'debug'" > Gemfile.local

    pushd ./plugins
    BRANCH="develop$(echo ${BASE} | tr -d '.')"
    git clone --depth 1 -b "${BRANCH}" "${CODE_REVIEW_URL}"
    git clone --depth 1 "${MAIL_TEMPLATE_URL}"
    popd

    bundle install --with development test
    bundle exec rake generate_secret_token
    bundle exec rake db:migrate
    echo ja | bundle exec rake redmine:load_default_data

    popd
done
