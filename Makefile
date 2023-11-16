.PHONY: help ps build build-prod start fresh fresh-prod stop restart destroy \
	cache cache-clear migrate migrate migrate-fresh tests tests-html

CONTAINER_PHP=api
CONTAINER_REDIS=redis
CONTAINER_DATABASE=database

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

	
auth: ## Authenticate with AWS
	aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 418381257785.dkr.ecr.eu-north-1.amazonaws.com

build-push: ## run build then push
	make build
	make push

build: ##build our rod image
	docker build -t prod-laravel-api-base-image .

push: ## push to prod image
	docker tag prod-laravel-api-base-image:latest 418381257785.dkr.ecr.eu-north-1.amazonaws.com/prod-laravel-api-base-image:latest
	docker push 418381257785.dkr.ecr.eu-north-1.amazonaws.com/prod-laravel-api-base-image:latest
