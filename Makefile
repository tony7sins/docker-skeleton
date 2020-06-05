init: clear init-emptry

init-emptry: .env.example
	@cp .env.example .env

clear: .env
	@rm -Rf .env