test:
	docker-compose up --build --force-recreate --exit-code-from apt-add-repository apt-add-repository
	docker-compose stop
	
clean:
	docker-compose down
