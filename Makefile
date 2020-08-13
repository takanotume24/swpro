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
	$(MAKE) clean
	$(MAKE) -C spec/docker-test/wget test
	$(MAKE) -C spec/docker-test/apt test
	$(MAKE) -C spec/docker-test/git test
	$(MAKE) clean

clean:
	$(MAKE) -C spec/docker-test/wget clean
	$(MAKE) -C spec/docker-test/apt clean
	$(MAKE) -C spec/docker-test/git clean

uninstall:
	sudo rm /bin/swpro
	rm -r ~/.swpro