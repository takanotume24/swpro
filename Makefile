build:
	crystal build src/cli.cr -o bin/swpro --release --static --verbose

update:
	git pull
	make build