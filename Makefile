SCRIPTS:=./bin
DEV_ENV=.env
DC="docker compose"

init-empty: init
	@echo 'Set privilages to ./bin scripts!' && chmod +x "${SCRIPTS}"/* 
	echo 'Creating new symfony 5 backend webskeleton...' && "${SCRIPTS}"/app.sh
	echo 'Please provide SSH selfsign certificates release...' && "${SCRIPTS}"/http2-self-certs.sh
	${DC} down -v --remove-orphans
	${DC} pull
	${DC} up -d --build

init: .env.example clear 
	@cp .env.example .env

clear:
	@[[ -f ${DEV_ENV} ]] && rm ${DEV_ENV} || echo 'Nothing to delete!'

permission: 
	@chmod -R u+rwx ./bin