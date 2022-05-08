tm_setup: build
	docker-compose run --rm task_manager 'bin/rails db:create db:migrate db:seed'

build:
	docker-compose build task_manager

up:
	docker-compose up task_manager

tm_bundle:
	docker-compose run --rm task_manager 'bundle install'
