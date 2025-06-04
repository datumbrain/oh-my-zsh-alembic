# oh-my-zsh-alembic

A comprehensive oh-my-zsh plugin for [Alembic](https://alembic.sqlalchemy.org/), the database migration tool for SQLAlchemy.

![](https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExN3E0bWQwMHZmZ29lMWkzN2lrNjZmMjJuaTE5eG9zeXE2bzJuZ2tpcyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/MRpYpP8DiBvkYmw6ir/giphy.gif)

## Features

- **Command aliases** for faster workflow
- **Tab completion** for all Alembic commands and options
- **Helper functions** for common operations
- **Status overview** functions
- Support for Alembic 1.16.1+

## Installation

### Using oh-my-zsh custom plugins

1. Clone this repository into your oh-my-zsh custom plugins directory:

   ```bash
   git clone https://github.com/datumbrain/oh-my-zsh-alembic.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alembic
   ```

2. Add `alembic` to your plugins list in `~/.zshrc`:

   ```bash
   plugins=(... alembic)
   ```

3. Reload your shell:

   ```bash
   source ~/.zshrc
   ```

### Manual Installation

1. Download `alembic.plugin.zsh`
2. Place it in `~/.oh-my-zsh/custom/plugins/alembic/`
3. Follow steps 2-3 above

## Usage

### Aliases

| Alias     | Command             | Description                |
| --------- | ------------------- | -------------------------- |
| `alc`     | `alembic current`   | Show current revision      |
| `alh`     | `alembic heads`     | Show available heads       |
| `alhist`  | `alembic history`   | Show revision history      |
| `alshow`  | `alembic show`      | Show specific revision     |
| `alup`    | `alembic upgrade`   | Upgrade to revision        |
| `aldown`  | `alembic downgrade` | Downgrade to revision      |
| `alrev`   | `alembic revision`  | Create new revision        |
| `albr`    | `alembic branches`  | Show branch points         |
| `alcheck` | `alembic check`     | Check for pending upgrades |
| `alstamp` | `alembic stamp`     | Stamp revision table       |
| `almerge` | `alembic merge`     | Merge revisions            |
| `aledit`  | `alembic edit`      | Edit revision file         |

### Helper Functions

- **`alup-head`** - Upgrade to head revision
- **`alrev-m "message"`** - Create revision with message
- **`alrev-auto "message"`** - Create auto-generated revision with message
- **`aldown-1`** - Downgrade by one revision
- **`alhist-v`** - Show verbose history
- **`alembic-status`** - Show comprehensive status overview
- **`alembic-init [directory]`** - Initialize Alembic with helpful reminders

### Tab Completion

The plugin provides intelligent tab completion for:

- All Alembic commands
- Command-specific options and flags
- File paths for configuration files
- Revision identifiers where applicable

## Examples

```bash
# Quick status check
alembic-status

# Create a new migration
alrev-auto "add user table"

# Upgrade to latest
alup-head

# Check what's pending
alcheck

# View recent history
alhist-v

# Downgrade one step
aldown-1
```

## Requirements

- [oh-my-zsh](https://ohmyz.sh/)
- [Alembic](https://alembic.sqlalchemy.org/) 1.16.1+
- Zsh with completion support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Alembic](https://alembic.sqlalchemy.org/) - The database migration tool
- [oh-my-zsh](https://ohmyz.sh/) - Framework for managing Zsh configuration
- The Zsh completion system documentation

---

**Note**: This plugin is not officially affiliated with Alembic or SQLAlchemy.

## Authors

- [Fahad Siddiqui](https://github.com/fahadsiddiqui) - Initial plugin development
