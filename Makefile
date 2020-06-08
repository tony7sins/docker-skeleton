init: clear init-emptry
	@./bin/app.sh

init-empty: .env.example
	@cp .env.example .env

clear: .env
	@rm -Rf .env