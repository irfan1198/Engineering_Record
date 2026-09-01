DOCUMENT ?= template/main_template.tex
PROJECT ?=
TEMPLATE ?= template/main_template.tex

REPO_ROOT := $(CURDIR)
SOURCE_DIR := $(patsubst %/,%,$(dir $(DOCUMENT)))
OUT_DIR := $(REPO_ROOT)/build/$(SOURCE_DIR)
PROJECT_DIR := records/$(PROJECT)
PROJECT_BUILD_DIR := $(REPO_ROOT)/build/records/$(PROJECT)

.PHONY: build clean new remove

new:
	@if [ -z "$(PROJECT)" ]; then \
		echo "Usage: make new PROJECT=project-a"; \
		exit 1; \
	fi
	@case "$(PROJECT)" in \
		*[!a-z0-9-]*|-*|*-) \
			echo "Error: PROJECT must use lowercase letters, numbers, and internal hyphens only."; \
			exit 1 ;; \
	esac
	@if [ ! -f "$(TEMPLATE)" ]; then \
		echo "Error: template not found: $(TEMPLATE)"; \
		exit 1; \
	fi
	@if [ -e "$(PROJECT_DIR)" ]; then \
		echo "Error: project already exists: $(PROJECT_DIR)"; \
		exit 1; \
	fi
	@mkdir -p records
	@mkdir "$(PROJECT_DIR)"
	@mkdir "$(PROJECT_DIR)/figures"
	@cp "$(TEMPLATE)" "$(PROJECT_DIR)/main.tex"
	@echo "Created $(PROJECT_DIR)/main.tex from $(TEMPLATE)"
	@echo "Build with: make build DOCUMENT=$(PROJECT_DIR)/main.tex"

remove:
	@if [ -z "$(PROJECT)" ]; then \
		echo "Usage: make remove PROJECT=project-a"; \
		exit 1; \
	fi
	@case "$(PROJECT)" in \
		*[!a-z0-9-]*|-*|*-) \
			echo "Error: PROJECT must use lowercase letters, numbers, and internal hyphens only."; \
			exit 1 ;; \
	esac
	@if [ ! -d "$(PROJECT_DIR)" ]; then \
		echo "Error: record not found: $(PROJECT_DIR)"; \
		exit 1; \
	fi
	@printf "Type '%s' to remove %s and its build output: " "$(PROJECT)" "$(PROJECT_DIR)"; \
	read -r confirmation; \
	if [ "$$confirmation" != "$(PROJECT)" ]; then \
		echo "Removal cancelled."; \
		exit 1; \
	fi; \
	rm -r -- "$(PROJECT_DIR)"; \
	if [ -d "$(PROJECT_BUILD_DIR)" ]; then \
		rm -r -- "$(PROJECT_BUILD_DIR)"; \
	fi; \
	echo "Removed $(PROJECT_DIR) and its build output."

build:
	mkdir -p "$(OUT_DIR)"
	latexmk -cd -pdf \
		-synctex=1 \
		-interaction=nonstopmode \
		-file-line-error \
		-halt-on-error \
		-outdir="$(OUT_DIR)" \
		-auxdir="$(OUT_DIR)" \
		"$(DOCUMENT)"

clean:
	latexmk -cd -C \
		-outdir="$(OUT_DIR)" \
		-auxdir="$(OUT_DIR)" \
		"$(DOCUMENT)"
