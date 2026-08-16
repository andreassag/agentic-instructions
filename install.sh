#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/andreassag/agentic-instructions.git"
DEFAULT_BRANCH="main"

PREFIX="" DRY_RUN=0 NO_PATH=0 UPDATE=0
VERSION="" TAG="" BRANCH=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --prefix)   PREFIX=$2; shift 2 ;;
    --version)  VERSION=$2; shift 2 ;;
    --tag)      TAG=$2; shift 2 ;;
    --branch)   BRANCH=$2; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    --no-path)  NO_PATH=1; shift ;;
    --update)   UPDATE=1; shift ;;
    -h|--help)  echo "Usage: install.sh [--prefix PATH] [--version VERSION] [--tag TAG] [--branch NAME] [--update] [--dry-run] [--no-path]"; exit 0 ;;
    *)          echo "Unknown flag: $1"; exit 1 ;;
  esac
done

TARGET_REF="${VERSION:-${TAG:-${BRANCH:-${DEFAULT_BRANCH}}}}"

[[ "${BASH_VERSINFO[0]}" -ge 4 ]] || { echo "bash >= 4.0 required (got $BASH_VERSION)"; exit 1; }

if [[ -z "$PREFIX" ]]; then
  if sudo -n true 2>/dev/null; then PREFIX="/usr/local"; else PREFIX="$HOME/.local"; fi
fi
HUB_SHARE="$PREFIX/share/agentic-instructions"
HUB_BIN="$PREFIX/bin/hub"

for tool in git; do
  command -v "$tool" >/dev/null 2>&1 || { echo "ERROR: '$tool' not found. Install: apt install $tool / brew install $tool"; exit 1; }
done

# --- Helper variables for OS and Architecture ---
OS_TYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH_TYPE="$(uname -m)"

# --- Auto-install jq if missing ---
if ! command -v jq >/dev/null 2>&1; then
  echo "Installing jq..."
  JQ_VERSION="jq-1.7.1"

  case "$OS_TYPE" in
    linux)  JQ_OS="linux" ;;
    darwin) JQ_OS="macos" ;;
    *) echo "Unsupported OS for automatic jq installation: $OS_TYPE"; exit 1 ;;
  esac

  case "$ARCH_TYPE" in
    x86_64)        JQ_ARCH="amd64" ;;
    aarch64|arm64) JQ_ARCH="arm64" ;;
    i386|i686)     JQ_ARCH="i386" ;;
    *) echo "Unsupported architecture for automatic jq installation: $ARCH_TYPE"; exit 1 ;;
  esac

  JQ_URL="https://github.com/jqlang/jq/releases/download/${JQ_VERSION}/jq-${JQ_OS}-${JQ_ARCH}"
  JQ_DEST="${PREFIX}/bin/jq"

  if [[ "$PREFIX" == "/usr/local" ]] && sudo -n true 2>/dev/null; then
    sudo wget -q "$JQ_URL" -O "$JQ_DEST" && sudo chmod +x "$JQ_DEST"
  else
    mkdir -p "${PREFIX}/bin"
    wget -q "$JQ_URL" -O "$JQ_DEST" && chmod +x "$JQ_DEST"
  fi
  echo "✓ Installed jq to $JQ_DEST"
fi

# --- Auto-install yq if missing or incompatible ---
INSTALL_YQ=0
if ! command -v yq >/dev/null 2>&1; then
  INSTALL_YQ=1
elif ! yq --version 2>&1 | grep -qE 'mikefarah|version v?[4-9]'; then
  echo "Incompatible yq variant detected."
  INSTALL_YQ=1
fi

if [[ $INSTALL_YQ -eq 1 ]]; then
  echo "Installing mikefarah/yq..."
  YQ_VERSION="v4.53.3"

  case "$ARCH_TYPE" in
    x86_64)        YQ_ARCH="amd64" ;;
    aarch64|arm64) YQ_ARCH="arm64" ;;
    armv7l)        YQ_ARCH="arm" ;;
    i386|i686)     YQ_ARCH="386" ;;
    *) echo "Unsupported architecture for automatic yq installation: $ARCH_TYPE"; exit 1 ;;
  esac

  YQ_PLATFORM="${OS_TYPE}_${YQ_ARCH}"
  YQ_URL="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${YQ_PLATFORM}"

  YQ_DEST="${PREFIX}/bin/yq"
  if [[ "$PREFIX" == "/usr/local" ]] && sudo -n true 2>/dev/null; then
    sudo wget -q "$YQ_URL" -O "$YQ_DEST" && sudo chmod +x "$YQ_DEST"
  else
    mkdir -p "${PREFIX}/bin"
    wget -q "$YQ_URL" -O "$YQ_DEST" && chmod +x "$YQ_DEST"
  fi
  echo "✓ Installed yq to $YQ_DEST"
fi

# --- Install graphify (pip install graphifyy && graphify install) ---
install_graphify() {
  if command -v graphify >/dev/null 2>&1; then
    echo "✓ graphify already installed ($(graphify --version 2>/dev/null || echo 'version unknown'))"
    return 0
  fi
  echo "Installing graphify..."
  if ! command -v python3 >/dev/null 2>&1; then
    echo "  ⚠ python3 not found — skipping graphify install. Install Python 3.10+ and re-run."
    return 0
  fi
  if ! python3 -c 'import sys; exit(0 if sys.version_info >= (3,10) else 1)' 2>/dev/null; then
    echo "  ⚠ Python 3.10+ required for graphify (got $(python3 --version 2>&1)) — skipping."
    return 0
  fi
  local pip_cmd="pip3"
  command -v pip3 >/dev/null 2>&1 || pip_cmd="pip"
  command -v "$pip_cmd" >/dev/null 2>&1 || { echo "  ⚠ pip not found — skipping graphify install."; return 0; }
  "$pip_cmd" install --quiet graphifyy 2>&1 | tail -1
  if command -v graphify >/dev/null 2>&1; then
    echo "✓ Installed graphify (pip package: graphifyy)"
    graphify install 2>/dev/null || echo "  ⚠ 'graphify install' returned non-zero — skill may need manual setup."
  else
    if command -v pipx >/dev/null 2>&1; then
      pipx install graphifyy --quiet 2>/dev/null
      echo "✓ Installed graphify via pipx"
    else
      echo "  ⚠ graphify binary not found after pip install."
      echo "    Try: pipx install graphifyy"
      echo "    Or add the Python Scripts directory to your PATH:"
      echo "    Linux/macOS: \$(python3 -m site --user-base)/bin"
    fi
  fi
}

# --- Install qmd (npm install -g @tobilu/qmd) ---
install_qmd() {
  if command -v qmd >/dev/null 2>&1; then
    echo "✓ qmd already installed"
    return 0
  fi
  echo "Installing qmd..."
  if command -v bun >/dev/null 2>&1; then
    bun install -g @tobilu/qmd --quiet 2>&1 | tail -2
    echo "✓ Installed qmd via bun"
  elif command -v npm >/dev/null 2>&1; then
    npm install -g @tobilu/qmd --quiet 2>&1 | tail -2
    echo "✓ Installed qmd via npm"
  else
    echo "  ⚠ Neither npm nor bun found — skipping qmd install."
    echo "    Install Node.js (https://nodejs.org) or Bun (https://bun.sh), then run:"
    echo "    npm install -g @tobilu/qmd"
  fi
}

# --- Install rtk (curl | sh from rtk-ai/rtk) ---
install_rtk() {
  if command -v rtk >/dev/null 2>&1; then
    echo "✓ rtk already installed ($(rtk --version 2>/dev/null || echo 'version unknown'))"
    return 0
  fi
  echo "Installing rtk..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
    if command -v rtk >/dev/null 2>&1; then
      echo "✓ Installed rtk"
    else
      echo "✓ rtk installed to ~/.local/bin (will be on PATH after shell restart)"
    fi
  elif command -v brew >/dev/null 2>&1; then
    brew install rtk --quiet
    echo "✓ Installed rtk via Homebrew"
  elif command -v cargo >/dev/null 2>&1; then
    cargo install --git https://github.com/rtk-ai/rtk --quiet
    echo "✓ Installed rtk via cargo"
  else
    echo "  ⚠ curl, brew, and cargo not found — skipping rtk install."
    echo "    Install curl and re-run, or install manually from:"
    echo "    https://github.com/rtk-ai/rtk/releases"
  fi
}

# --- Run tool installations ---
install_graphify
install_qmd
install_rtk

# --- Helper function for sudo execution when needed ---
run_cmd() {
  if [[ "$PREFIX" == "/usr/local" ]] && sudo -n true 2>/dev/null; then
    sudo "$@"
  else
    "$@"
  fi
}

# --- Auto-detect local development repository ---
IS_LOCAL_REPO=0
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" 2>/dev/null && pwd)"
  if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/hub.sh" && -d "$SCRIPT_DIR/agents" && -d "$SCRIPT_DIR/instructions" ]]; then
    IS_LOCAL_REPO=1
  fi
fi

# --- Clone, update, or link local repo ---
if [[ $IS_LOCAL_REPO -eq 1 && -z "$VERSION" && -z "$TAG" && -z "$BRANCH" ]]; then
  echo "Using local repository at $SCRIPT_DIR"
  if [[ $DRY_RUN -eq 0 ]]; then
    run_cmd mkdir -p "$(dirname "$HUB_SHARE")"
    if [[ -d "$HUB_SHARE" && ! -L "$HUB_SHARE" ]]; then
      run_cmd rm -rf "$HUB_SHARE"
    fi
    run_cmd ln -sfn "$SCRIPT_DIR" "$HUB_SHARE"
    echo "✓ Linked $HUB_SHARE -> $SCRIPT_DIR"
  fi
elif [[ -d "$HUB_SHARE/.git" ]]; then
  if [[ $UPDATE -eq 1 || -n "$VERSION" || -n "$TAG" || -n "$BRANCH" ]]; then
    echo "Updating hub to $TARGET_REF..."
    if [[ $DRY_RUN -eq 0 ]]; then
      run_cmd git -C "$HUB_SHARE" fetch --tags origin || true
      if run_cmd git -C "$HUB_SHARE" fetch origin "$TARGET_REF" 2>/dev/null; then
        run_cmd git -C "$HUB_SHARE" checkout -f FETCH_HEAD
      elif run_cmd git -C "$HUB_SHARE" checkout -f "$TARGET_REF" 2>/dev/null; then
        :
      elif run_cmd git -C "$HUB_SHARE" checkout -f "v$TARGET_REF" 2>/dev/null; then
        :
      else
        echo "ERROR: Version/ref '$TARGET_REF' not found."
        exit 1
      fi
      echo "✓ Updated to $TARGET_REF"
    fi
  else
    echo "hub already installed at $HUB_SHARE. Use --update or --version to upgrade/switch."
  fi
else
  echo "Installing hub ($TARGET_REF) to $HUB_SHARE..."
  if [[ $DRY_RUN -eq 0 ]]; then
    run_cmd mkdir -p "$(dirname "$HUB_SHARE")"
    if ! run_cmd git clone --depth=1 -b "$TARGET_REF" "$REPO_URL" "$HUB_SHARE" 2>/dev/null; then
      if [[ "$TARGET_REF" != v* ]] && run_cmd git clone --depth=1 -b "v$TARGET_REF" "$REPO_URL" "$HUB_SHARE" 2>/dev/null; then
        :
      else
        run_cmd git clone "$REPO_URL" "$HUB_SHARE"
        run_cmd git -C "$HUB_SHARE" checkout -f "$TARGET_REF" || run_cmd git -C "$HUB_SHARE" checkout -f "v$TARGET_REF"
      fi
    fi
    echo "✓ Installed version $TARGET_REF"
  fi
fi

# --- Symlink ---
if [[ $DRY_RUN -eq 0 ]]; then
  run_cmd mkdir -p "$PREFIX/bin"
  run_cmd ln -sf "$HUB_SHARE/hub.sh" "$HUB_BIN"
  run_cmd chmod +x "$HUB_SHARE/hub.sh"
fi

if [[ $NO_PATH -eq 0 ]] && ! echo "$PATH" | tr ':' '\n' | grep -qx "$PREFIX/bin"; then
  RC="$HOME/.bashrc"; [[ "${SHELL:-}" == *zsh* ]] && RC="$HOME/.zshrc"
  [[ $DRY_RUN -eq 0 ]] && printf '\nexport PATH="%s/bin:$PATH"\n' "$PREFIX" >> "$RC"
  echo "Added $PREFIX/bin to PATH in $RC. Restart your shell or: source $RC"
fi

echo "✓ hub installed. Run: hub --help"
