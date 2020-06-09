SCRIPTS:=./bin
DEV_ENV=.env

init-empty: init
	@${SCRIPTS}/app.sh

init: .env.example clear 
	@cp .env.example .env

clear:
	@[[ -f ${DEV_ENV} ]] && rm ${DEV_ENV} || echo 'Nothing to delete!'