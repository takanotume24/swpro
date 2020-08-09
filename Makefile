build:
	shards build --release --static --verbose

install:
	sudo ./bin/swpro install

install-with-crystal-env:
	$(MAKE) init-crystal-env
	$(MAKE) build
	sudo ./bin/swpro install

init-crystal-env:
	sudo apt update
	sudo apt install curl wget -y
	curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
	sudo apt install crystal libgmp-dev libz-dev libreadline-dev libyaml-dev libssl-dev libxml2-dev  -y

update:
	git pull
	$(MAKE) build

test:
	$(MAKE) -C spec/docker/wget test
	$(MAKE) -C spec/docker/apt test
	$(MAKE) clean

clean:
	$(MAKE) -C spec/docker/wget clean
	$(MAKE) -C spec/docker/apt clean

uninstall:
	sudo rm /bin/swpro
	rm ~/.swpro.json