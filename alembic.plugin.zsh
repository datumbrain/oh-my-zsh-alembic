# Enhanced Alembic plugin for oh-my-zsh
# Provides comprehensive completion and aliases for Alembic database migration tool
# Compatible with Alembic 1.16.1

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
alias alinit='alembic init'
alias alensure='alembic ensure_version'
alias allist='alembic list_templates'

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

# Enhanced completion function for alembic with all commands and flags
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
            '--verbose[Use more verbose output]' \
            $global_options
        ;;
    check)
        _arguments \
            $global_options
        ;;
    current)
        _arguments \
            '-v[Use more verbose output]' \
            '--verbose[Use more verbose output]' \
            $global_options
        ;;
    downgrade)
        _arguments \
            '--sql[Don'\''t emit SQL to database - dump to stdout instead]' \
            '--tag[Arbitrary tag name]:tag' \
            ':revision:' \
            $global_options
        ;;
    edit)
        _arguments \
            ':revision:' \
            $global_options
        ;;
    ensure_version)
        _arguments \
            '--sql[Don'\''t emit SQL to database - dump to stdout instead]' \
            $global_options
        ;;
    heads)
        _arguments \
            '-v[Use more verbose output]' \
            '--verbose[Use more verbose output]' \
            '--resolve-dependencies[Treat dependency versions as down revisions]' \
            $global_options
        ;;
    history)
        _arguments \
            '-r[Specify a revision range]:range' \
            '--rev-range[Specify a revision range]:range' \
            '-v[Use more verbose output]' \
            '--verbose[Use more verbose output]' \
            '-i[Indicate current revision]' \
            '--indicate-current[Indicate current revision]' \
            $global_options
        ;;
    init)
        _arguments \
            '--template[Repository template to use]:template:(generic multidb async pyproject)' \
            '--package[Write empty __init__.py files to versions directory]' \
            ':directory:_directories' \
            $global_options
        ;;
    list_templates)
        _arguments \
            $global_options
        ;;
    merge)
        _arguments \
            '--rev-id[Specify a hardcoded revision id]:id' \
            '-m[Message string to use with revision]:message' \
            '--message[Message string to use with revision]:message' \
            '--branch-label[Specify a branch label]:label' \
            ':revisions:' \
            $global_options
        ;;
    revision)
        _arguments \
            '--rev-id[Specify a hardcoded revision id]:id' \
            '-m[Message string to use with revision]:message' \
            '--message[Message string to use with revision]:message' \
            '--autogenerate[Populate revision script with candidate migration operations]' \
            '--sql[Don'\''t emit SQL to database - dump to stdout instead]' \
            '--head[Specify head revision]:head' \
            '--splice[Allow a non-head revision as the head]' \
            '--branch-label[Specify a branch label]:label' \
            '--version-path[Specify specific path for version file]:path:_directories' \
            '--depends-on[Specify one or more revision identifiers]:revision' \
            $global_options
        ;;
    show)
        _arguments \
            ':revision:' \
            $global_options
        ;;
    stamp)
        _arguments \
            '--sql[Don'\''t emit SQL to database - dump to stdout instead]' \
            '--tag[Arbitrary tag name]:tag' \
            '--purge[Delete all entries in version table before stamping]' \
            ':revision:' \
            $global_options
        ;;
    upgrade)
        _arguments \
            '--sql[Don'\''t emit SQL to database - dump to stdout instead]' \
            '--tag[Arbitrary tag name]:tag' \
            ':revision:' \
            $global_options
        ;;
    esac

    return 0
}

# Register the completion function
compdef _alembic alembic

# Additional helper functions
alembic-status() {
    echo "=== Alembic Status ==="
    echo "\n📍 Current revision:"
    alembic current -v
    echo "\n🔝 Available heads:"
    alembic heads -v
    echo "\n🔍 Checking for pending changes:"
    if alembic check 2>/dev/null; then
        echo "✅ No pending upgrades detected"
    else
        echo "⚠️  Pending changes detected - run 'alembic revision --autogenerate' to create migration"
    fi
}

# Function to initialize alembic in current directory
alembic-init() {
    local dir_name=${1:-alembic}
    local template=${2:-generic}

    echo "🚀 Initializing Alembic..."
    alembic init --template="$template" "$dir_name"

    if [[ $? -eq 0 ]]; then
        echo "✅ Alembic initialized successfully!"
        echo "📁 Directory: $dir_name"
        echo "📄 Template: $template"
        echo "\n⚠️  Don't forget to configure your database URL in alembic.ini"
        echo "💡 Next steps:"
        echo "   1. Edit alembic.ini and set sqlalchemy.url"
        echo "   2. Edit $dir_name/env.py if needed"
        echo "   3. Create your first migration: alembic revision -m 'initial migration'"
    else
        echo "❌ Failed to initialize Alembic"
    fi
}

# Function to show alembic help with enhanced formatting
alembic-help() {
    echo "🔧 Enhanced Alembic Commands & Aliases"
    echo "======================================"
    echo
    echo "📋 Basic Commands:"
    echo "  alc          → alembic current         (show current revision)"
    echo "  alh          → alembic heads           (show available heads)"
    echo "  alhist       → alembic history         (show revision history)"
    echo "  alshow       → alembic show            (show specific revision)"
    echo "  alup         → alembic upgrade         (upgrade database)"
    echo "  aldown       → alembic downgrade       (downgrade database)"
    echo "  alrev        → alembic revision        (create new revision)"
    echo "  albr         → alembic branches        (show branch points)"
    echo "  alcheck      → alembic check           (check for pending changes)"
    echo "  alstamp      → alembic stamp           (stamp revision without running)"
    echo "  almerge      → alembic merge           (merge revisions)"
    echo "  aledit       → alembic edit            (edit revision file)"
    echo "  alinit       → alembic init            (initialize alembic)"
    echo "  alensure     → alembic ensure_version  (create version table)"
    echo "  allist       → alembic list_templates  (list available templates)"
    echo
    echo "🔄 Helper Functions:"
    echo "  alup-head    → alembic upgrade head    (upgrade to latest)"
    echo "  alrev-m      → alembic revision -m     (create revision with message)"
    echo "  alrev-auto   → alembic revision --autogenerate -m (auto-generate revision)"
    echo "  aldown-1     → alembic downgrade -1    (downgrade by one)"
    echo "  alhist-v     → alembic history --verbose (verbose history)"
    echo
    echo "🔧 Enhanced Functions:"
    echo "  alembic-status    → Show comprehensive status"
    echo "  alembic-init      → Enhanced initialization with templates"
    echo "  alembic-help      → Show this help"
    echo
    echo "💡 Pro Tips:"
    echo "  • Use TAB completion for commands and flags"
    echo "  • All flags support autocompletion (try: alembic revision --<TAB>)"
    echo "  • Templates available: generic, multidb, async, pyproject"
    echo "  • Use -x flag for custom parameters: alembic -x data=true upgrade head"
}

# Function to create a revision with enhanced prompts
alembic-create() {
    local message=""
    local autogenerate=false
    local head="head"
    local branch_label=""

    # Interactive mode if no arguments
    if [[ $# -eq 0 ]]; then
        echo "🔧 Interactive Revision Creation"
        echo "==============================="
        read "message?📝 Enter revision message: "
        read "auto?🤖 Auto-generate from model changes? (y/N): "
        if [[ "$auto" =~ ^[Yy]$ ]]; then
            autogenerate=true
        fi
        read "branch?🌲 Branch label (optional): "
        if [[ -n "$branch" ]]; then
            branch_label="--branch-label=$branch"
        fi
    else
        message="$1"
        shift
        while [[ $# -gt 0 ]]; do
            case $1 in
            --auto | --autogenerate)
                autogenerate=true
                shift
                ;;
            --branch-label=*)
                branch_label="$1"
                shift
                ;;
            --head=*)
                head="${1#*=}"
                shift
                ;;
            *)
                shift
                ;;
            esac
        done
    fi

    if [[ -z "$message" ]]; then
        echo "❌ Error: Revision message is required"
        return 1
    fi

    echo "🚀 Creating revision..."
    local cmd="alembic revision -m \"$message\""
    if [[ "$autogenerate" = true ]]; then
        cmd="$cmd --autogenerate"
    fi
    if [[ -n "$branch_label" ]]; then
        cmd="$cmd $branch_label"
    fi
    if [[ "$head" != "head" ]]; then
        cmd="$cmd --head=$head"
    fi

    echo "📋 Command: $cmd"
    eval "$cmd"

    if [[ $? -eq 0 ]]; then
        echo "✅ Revision created successfully!"
        echo "💡 Next: Review the generated file and run 'alembic upgrade head'"
    else
        echo "❌ Failed to create revision"
    fi
}

# Function to show revision diff
alembic-diff() {
    local rev1=${1:-"current"}
    local rev2=${2:-"head"}

    echo "🔍 Showing differences between $rev1 and $rev2"
    echo "=============================================="

    if command -v git >/dev/null 2>&1; then
        alembic show "$rev1" >/tmp/alembic_rev1.txt
        alembic show "$rev2" >/tmp/alembic_rev2.txt
        git diff --no-index /tmp/alembic_rev1.txt /tmp/alembic_rev2.txt || true
        rm -f /tmp/alembic_rev1.txt /tmp/alembic_rev2.txt
    else
        echo "📝 Revision $rev1:"
        alembic show "$rev1"
        echo "\n📝 Revision $rev2:"
        alembic show "$rev2"
    fi
}

# Enhanced autocomplete for revision identifiers
_alembic_revisions() {
    local revisions
    revisions=($(alembic history --verbose 2>/dev/null | grep -E '^[0-9a-f]+' | cut -d' ' -f1))
    revisions+=(head current base)
    _describe 'revisions' revisions
}

# Override revision completion with actual revision IDs
_alembic_revision_completion() {
    case "$words[2]" in
    show | stamp | upgrade | downgrade)
        _alembic_revisions
        ;;
    *)
        _alembic
        ;;
    esac
}

# Enhanced completion for specific commands that need revision IDs
compdef _alembic_revision_completion alembic
