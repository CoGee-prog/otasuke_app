#!/bin/bash
set -e

if [ "$RAILS_ENV" = "development" ]; then
	# DBがなければ作成
	bundle exec rails db:create || true
	# マイグレーション
	bundle exec rails db:migrate || true
fi

# 本来のサーバー起動
exec "$@"


