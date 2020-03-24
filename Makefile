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
	sudo apt install crystal -y
	sudo apt install libssl-dev  -y    # for using OpenSSL
	sudo apt install libxml2-dev -y     # for using XML
	sudo apt install libyaml-dev -y     # for using YAML
	sudo apt install libgmp-dev -y     # for using Big numbers
	sudo apt install libreadline-dev -y # for using Readline
	sudo apt install libz-dev -y       # for using crystal play

update:
	git pull
	make build

uninstall:
	sudo rm /bin/swpro
	rm ~/.swpro.json