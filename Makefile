.PHONY: build dev pull up install

build: up
	ddev exec npm install
	ddev exec npm run build
dev: build
	ddev exec npm run serve
pull: up
	ddev composer install
install: up build
	ddev exec php craft setup/app-id \
		$(filter-out $@,$(MAKECMDGOALS))
	ddev exec php craft setup/security-key \
		$(filter-out $@,$(MAKECMDGOALS))
	ddev exec php craft install \
		$(filter-out $@,$(MAKECMDGOALS))
	@echo "Do you want to install the craft plugins? (yes/no)"
	@read answer; \
	if [ "$$answer" = "yes" ]; then \
		ddev exec php craft plugin/install vite; \
		ddev exec php craft plugin/install seomatic; \
		ddev exec php craft plugin/install retour; \
		ddev exec php craft plugin/install freeform; \
		ddev exec php craft plugin/install ckeditor; \

setup:
	ddev composer install
	ddev exec npm install
up: setup
	if [ ! "$$(ddev describe | grep OK)" ]; then \
        ddev auth ssh; \
        ddev start; \
    fi
%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
