# WIP

# TODO: get github dependencies from staged_dependencies.yml (from admiral repo) and install them
STAGED_DEP_REF="devel"

# Declare an array of string with type
declare -A github_deps

github_deps="pharmaverse/admiraldev \
pharmaverse/admiral.test"

for dep in $github_deps; do
    echo "Install ${dep} - ref ${STAGED_DEP_REF}"
    R -e "remotes::install_github('${dep}', ref = '${STAGED_DEP_REF}', dependencies = 'FALSE')"
done