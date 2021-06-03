help:
	@echo "make"
	@echo "    clean"
	@echo "        Remove Python/build artifacts."
	@echo "    formatter"
	@echo "        Apply black formatting to code."
	@echo "    lint"
	@echo "        Lint code with flake8, and check if black formatter should be applied."
	@echo "    types"
	@echo "        Check for type errors using pytype."
	@echo "    validate"
	@echo "        Runs the rasa data validate to verify data."
	@echo "    test"
	@echo "        Runs the rasa test suite checking for issues."
	@echo "    crossval"
	@echo "        Runs the rasa cross validation tests and creates results.md"
	@echo "    shell"
	@echo "        Runs the rasa train and rasa shell for testing"
	@echo "    install"
	@echo "        Install all requirements for running the bot."
	@echo "    install-dev"
	@echo "        Install all requirements for development."
	@echo "    test-actions"
	@echo "        Run custom action unit tests"	


install:
	pip install -r requirements.txt
	python -m spacy download ru_core_news_md
	python -m spacy link ru_core_news_md ru
	pip install -e .

install-dev:
	pip install -r requirements-dev.txt
	python -m spacy download ru_core_news_md
	pip install -e .

clean:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f  {} +
	rm -rf build/
	rm -rf .pytype/
	rm -rf dist/
	rm -rf docs/_build

formatter:
	black actions --line-length 79

lint:
	flake8 actions tests
	black --check --verbose --config pyproject.toml actions tests	

types:
	pytype --keep-going actions

validate:
	rasa train
	rasa data validate --debug

test:
	rasa train
	rasa test --fail-on-prediction-errors

test-actions:
	pytest . -vv

crossval:
	rasa test nlu -f 5 --cross-validation
	python format_results.py

shell:
	rasa train --debug
	rasa shell --debug