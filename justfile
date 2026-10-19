# zlc-courses commands.
# Install `just` via: brew install just
# Then run e.g. `just sync` from the repo root.

# Default recipe — show available commands.
default:
    @just --list

# === Python / uv ===

# Install/refresh the virtual environment from pyproject.toml + uv.lock.
sync:
    uv sync

# Add a dependency. Usage: just add pkg=polars
add pkg:
    uv add {{pkg}}

# Run a command in the project venv. Usage: just run cmd="python foo.py"
run cmd:
    uv run {{cmd}}

# Launch Jupyter Lab in the project venv.
lab:
    uv run jupyter lab

# === Publishing ===

# Stage, commit, and push everything.
publish msg="Update":
    git add -A
    git commit -m "{{msg}}"
    git push
