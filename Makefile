DOCUMENT ?= template/main_template.tex
PROJECT ?=
TEMPLATE ?= template/main_template.tex

export PROJECT TEMPLATE

REPO_ROOT := $(CURDIR)
SOURCE_DIR := $(patsubst %/,%,$(dir $(DOCUMENT)))
OUT_DIR := $(REPO_ROOT)/build/$(SOURCE_DIR)
PROJECT_DIR := records/$(PROJECT)
PROJECT_BUILD_DIR := $(REPO_ROOT)/build/records/$(PROJECT)

.PHONY: build clean new remove

new:
	@set -eu; \
	raw_project="$${PROJECT-}"; \
	template="$${TEMPLATE-}"; \
	if [ -z "$$raw_project" ]; then \
		echo 'Usage: make new PROJECT="Project Name"'; \
		exit 1; \
	fi; \
	case "$$raw_project" in \
		*[!A-Za-z0-9\ -]*) \
			echo "Error: PROJECT may only contain letters, numbers, spaces, and hyphens."; \
			exit 1 ;; \
	esac; \
	project_slug=$$(printf '%s' "$$raw_project" \
		| tr '[:upper:]' '[:lower:]' \
		| sed -E 's/[[:space:]-]+/-/g; s/^-//; s/-+$$//'); \
	if [ -z "$$project_slug" ]; then \
		echo "Error: PROJECT must contain at least one letter or number."; \
		exit 1; \
	fi; \
	project_dir="records/$$project_slug"; \
	if [ ! -f "$$template" ]; then \
		echo "Error: template not found: $$template"; \
		exit 1; \
	fi; \
	if [ -e "$$project_dir" ]; then \
		echo "Error: project already exists: $$project_dir"; \
		exit 1; \
	fi; \
	if [ "$$raw_project" != "$$project_slug" ]; then \
		printf "Normalized project name: %s -> %s\n" "$$raw_project" "$$project_slug"; \
	fi; \
	mkdir -p records; \
	mkdir "$$project_dir"; \
	mkdir "$$project_dir/figures"; \
	cp "$$template" "$$project_dir/main.tex"; \
	echo "Created $$project_dir/main.tex from $$template"; \
	echo "Build with: make build DOCUMENT=$$project_dir/main.tex"

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
