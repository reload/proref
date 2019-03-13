up:
ifeq ($(shell uname), Darwin)
	docker-compose -f docker-compose.yml -f docker-compose-mac.yml up -d
else
	docker-compose up -d
endif

	# Tada!! 🎉 Run 'make logs' to follow output.

down:
ifeq ($(shell uname), Darwin)
	docker-compose -f docker-compose.yml -f docker-compose-mac.yml stop
	docker-compose -f docker-compose.yml -f docker-compose-mac.yml down -v
else
	docker-compose stop
	docker-compose down -v --remove-orphans
endif

logs:
	@docker-compose logs -f
