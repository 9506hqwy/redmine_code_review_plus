# Redmine Code Review Plus

This plugin provides a extension for [redmine_code_review](https://github.com/haru/redmine_code_review) plugin.

## Features

- Show code review list in attachment file view.
- Show code snippet of review point in code review issue.
- Send mail with code snippet of reviw point (need to use [redmine_mail_template](https://github.com/9506hqwy/redmine_mail_template)).

## Installation

1. Download plugin in Redmine plugin directory.
   ```sh
   git clone https://github.com/9506hqwy/redmine_code_review_plus.git
   ```
2. Install redmine_code_review plugin.
3. Start Redmine

## Tested Environment

* Redmine (Docker Image)
  * 3.4
  * 4.0
  * 4.1
  * 4.2
  * 5.0
  * 5.1
  * 6.0
* Database
  * SQLite
  * MySQL 5.7 or 8.0
  * PostgreSQL 12
