# Alembic plugin for oh-my-zsh
# Provides completion and aliases for Alembic database migration tool

# Aliases for common Alembic commands
alias alc='alembic current'
alias alh='alembic heads'
alias alhist='alembic history'
alias alshow='alembic show'
alias alup='alembic upgrade'
alias aldown='alembic downgrade'
alias alrev='alembic revision'
alias albr='alembic branches'
alias alcheck='alembic check'
alias alstamp='alembic stamp'
alias almerge='alembic merge'
alias aledit='alembic edit'

# Function to upgrade to head
alup-head() {
    alembic upgrade head
}

# Function to create new revision with message
alrev-m() {
    if [[ -z "$1" ]]; then
        echo "Usage: alrev-m 'revision message'"
        return 1
    fi
    alembic revision -m "$1"
}

# Function to create auto-generated revision
alrev-auto() {
    if [[ -z "$1" ]]; then
        echo "Usage: alrev-auto 'revision message'"
        return 1
    fi
    alembic revision --autogenerate -m "$1"
}

# Function to downgrade by one revision
aldown-1() {
    alembic downgrade -1
}

# Function to show history with verbose output
alhist-v() {
    alembic history --verbose
}

# Completion function for alembic
_alembic() {
    local -a commands
    commands=(
        'branches:Show current branch points'
        'check:Check if revision command with autogenerate has pending upgrade ops'
        'current:Display current revision for each database'
        'downgrade:Revert to a previous version'
        'edit:Edit a revision file'
        'ensure_version:Create the alembic version table'
        'heads:Show current available heads in the script directory'
        'history:List changeset scripts in chronological order'
        'init:Initialize a new scripts directory'
        'list_templates:List available templates'
        'merge:Merge two revisions together'
        'revision:Create a new revision file'
        'show:Show the revision denoted by the given symbol'
        'stamp:Stamp the revision table with the given revision'
        'upgrade:Upgrade to a later version'
    )

    local -a global_options
    global_options=(
        '-h[Show help message and exit]'
        '--help[Show help message and exit]'
        '--version[Show program version and exit]'
        '-c[Alternate config file]:config file:_files'
        '--config[Alternate config file]:config file:_files'
        '-n[Name of section in .ini file]:name'
        '--name[Name of section in .ini file]:name'
        '-x[Additional arguments]:args'
        '--raiseerr[Raise a full stack trace on error]'
        '-q[Don'\''t emit any output]'
        '--quiet[Don'\''t emit any output]'
    )

    if ((CURRENT == 2)); then
        _describe 'alembic commands' commands
        return 0
    fi

    case "$words[2]" in
    branches)
        _arguments \
            '-v[Use more verbose output]' \
            '--verbose[Use more verbose output]'
        ;;
    current)
        _arguments \
            '-v[Use more verbose output]' \
            '--verbose[Use more verbose output]'
        ;;
    downgrade)
        _arguments \
            '--sql[Don'\''t emit SQL to database]' \
            '--tag[Arbitrary tag name]:tag' \
            ':revision:'
        ;;
    heads)
        _arguments \
            '-v[Use more verbose output]' \
            '--verbose[Use more verbose output]' \
            '--resolve-dependencies[Treat dependency versions as down revisions]'
        ;;
    history)
        _arguments \
            '-r[Specify a revision range]:range' \
            '--rev-range[Specify a revision range]:range' \
            '-v[Use more verbose output]' \
            '--verbose[Use more verbose output]' \
            '-i[Indicate current revision]' \
            '--indicate-current[Indicate current revision]'
        ;;
    init)
        _arguments \
            '--template[Repository template to use]:template' \
            '--package[Write empty __init__.py files]' \
            ':directory:_directories'
        ;;
    merge)
        _arguments \
            '--rev-id[Specify a hardcoded revision id]:id' \
            '-m[Message string to use with revision]:message' \
            '--message[Message string to use with revision]:message' \
            '--branch-label[Specify a branch label]:label' \
            ':revisions:'
        ;;
    revision)
        _arguments \
            '--rev-id[Specify a hardcoded revision id]:id' \
            '-m[Message string to use with revision]:message' \
            '--message[Message string to use with revision]:message' \
            '--autogenerate[Populate revision script with candidate migration operations]' \
            '--sql[Don'\''t emit SQL to database]' \
            '--head[Specify head revision]:head' \
            '--splice[Allow a non-head revision as the head]' \
            '--branch-label[Specify a branch label]:label' \
            '--version-path[Specify specific path for version file]:path:_directories' \
            '--depends-on[Specify one or more revision identifiers]:revision'
        ;;
    show)
        _arguments \
            ':revision:'
        ;;
    stamp)
        _arguments \
            '--sql[Don'\''t emit SQL to database]' \
            '--tag[Arbitrary tag name]:tag' \
            '--purge[Delete all entries in version table before stamping]' \
            ':revision:'
        ;;
    upgrade)
        _arguments \
            '--sql[Don'\''t emit SQL to database]' \
            '--tag[Arbitrary tag name]:tag' \
            ':revision:'
        ;;
    esac

    return 0
}

# Register the completion function
compdef _alembic alembic

# Additional helper functions
alembic-status() {
    echo "Current revision:"
    alembic current
    echo "\nAvailable heads:"
    alembic heads
    echo "\nPending upgrades:"
    alembic check 2>/dev/null || echo "No pending upgrades or check command failed"
}

# Function to initialize alembic in current directory
alembic-init() {
    local dir_name=${1:-alembic}
    alembic init $dir_name
    echo "Alembic initialized in directory: $dir_name"
    echo "Don't forget to configure your database URL in alembic.ini"
}
