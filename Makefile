build:
	shards
	crystal build src/cli.cr -o bin/swpro --release --static --verbose

install:
	sudo ./bin/swpro install

install-with-crystal-env:
	make init-crystal-env
	make build
	sudo ./bin/swpro install

init-crystal-env:
	sudo apt update
	sudo apt install curl wget -y
	curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
	sudo apt install crystal libgmp-dev libz-dev libreadline-dev libyaml-dev libssl-dev libxml2-dev  -y

update:
	git pull
	make build

uninstall:
	sudo rm /bin/swpro
	rm ~/.swpro.json