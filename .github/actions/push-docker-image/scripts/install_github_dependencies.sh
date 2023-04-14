# WIP

# TODO: get github dependencies from staged_dependencies.yml (from admiral repo) and install them


# Declare an array of string with type
declare -a github_deps=("pharmaverse/admiraldev" "pharmaverse/admiral.test" )

# Iterate the string array using for loop
for dep in ${github_deps[@]}; do
    echo "Install ${dep} - ref ${STAGED_DEP_REF}"
    R -e "remotes::install_github('${dep}', ref = '${STAGED_DEP_REF}', dependencies = 'FALSE')"
done

