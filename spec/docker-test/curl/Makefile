test:
	docker-compose up --build --force-recreate --exit-code-from curl curl
	docker-compose stop
	
clean:
	docker-compose down
