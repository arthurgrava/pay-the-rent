UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Linux)
    OPEN_EXECUTABLE ?= xdg-open
endif
ifeq ($(UNAME_S), Darwin)
    OPEN_EXECUTABLE ?= open
endif
OPEN_EXECUTABLE ?= :

clean:
	@find . -name "*.pyc" | xargs rm -rf
	@find . -name "*.pyo" | xargs rm -rf
	@find . -name "__pycache__" -type d | xargs rm -rf
	@find . -name "dist" -type d | xargs rm -rf
	@find . -name "htmlcov" | xargs rm -rf
	@find . -name ".coverage" | xargs rm -rf
	@find . -name ".cache" | xargs rm -rf
	@find . -name "*.log" | xargs rm -rf

flake8: clean
	@flake8 . --show-source --exclude=manage.py,*setting/base.py,*migrations*

shell: clean
	python django/manage.py shell --settings=srbarriga.setting.development

server-dev: clean
	python django/manage.py runserver --settings=srbarriga.setting.development

test: flake8
	cd django && py.test -vv -xs

coverage: flake8
	cd django && py.test -xs --cov-report=term --cov=mailer

coverage-html: flake8
	cd django && py.test -xs --cov-report=term --cov-report=html --cov=mailer

open-coverage: coverage-html
	$(OPEN_EXECUTABLE) django/htmlcov/index.html
