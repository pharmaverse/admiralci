#!/bin/bash

# move script rstudio into /usr/bin
cp "$(pwd)/.devcontainer/rstudio.sh" /usr/bin/rstudio

# Restore renv and install staged dependencies
R -q -e 'renv::activate(profile = paste(R.version$major, substr(R.version$minor, 1, 1), sep = ".")); renv::restore(); staged.dependencies::install_deps(staged.dependencies::dependency_table(project = ".", verbose = 1), verbose = 1);'

# Define rstudio default working directory
jq --arg folder "$(pwd)/" '. + { "initial_working_directory": $folder }' .devcontainer/rstudio-prefs.json > ~/.config/rstudio/rstudio-prefs.json