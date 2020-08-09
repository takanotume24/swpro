test:
	docker-compose up --build --force-recreate --exit-code-from wget wget
	docker-compose stop
	
clean:
	docker-compose down