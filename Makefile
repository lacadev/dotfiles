# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# and https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
# Make help the default target
.DEFAULT_GOAL := help

IMAGE=dotfiles

test-build: ## Build the container image to test
	@docker build -t "$(IMAGE)" .

test-build-nc: ## Build the container image to test without caching layers
	@docker build --no-cache -t "$(IMAGE)" .

test: ## Run tests on container
	@docker run -it --rm --name="$(IMAGE)" -v "$(shell pwd):/tmp/dotfiles" "$(IMAGE)-test" bats /tmp/dotfiles/test.bats

exec: ## Install dotfiles and enter the container
	@docker run -it --rm --name="$(IMAGE)" -v "$(shell pwd):/tmp/dotfiles" "$(IMAGE)" bash
