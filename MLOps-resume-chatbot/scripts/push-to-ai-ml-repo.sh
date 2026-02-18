#!/usr/bin/env bash
# Push this project to https://github.com/yuantian94/AI-ML-Projects.git
# as subdirectory MLOps-resume-chatbot, excluding week2 and build artifacts.
# Run from project root: bash scripts/push-to-ai-ml-repo.sh

set -e
REPO_URL="https://github.com/yuantian94/AI-ML-Projects.git"
SUBDIR="MLOps-resume-chatbot"
CLONE_DIR="../AI-ML-Projects-push"
SRC_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Exclude: week2, .git, build/venv artifacts, env files, large binaries
EXCLUDES=(
  "week2"
  ".git"
  "node_modules"
  ".next"
  "out"
  ".venv"
  "__pycache__"
  "lambda-package"
  ".env"
  ".env.*"
  "*.zip"
  "*.tfstate"
  "*.tfstate.*"
  ".terraform"
  "uv.lock"
)

echo "=== Safe push to AI-ML-Projects as $SUBDIR (excluding week2) ==="
echo "Source: $SRC_ROOT"
echo ""

# Clone or pull the target repo
if [ ! -d "$CLONE_DIR" ]; then
  echo "Cloning $REPO_URL into $CLONE_DIR ..."
  git clone "$REPO_URL" "$CLONE_DIR"
else
  echo "Updating existing clone at $CLONE_DIR ..."
  (cd "$CLONE_DIR" && git fetch origin && git checkout main && git pull origin main)
fi

DEST="$CLONE_DIR/$SUBDIR"
mkdir -p "$DEST"

# Build rsync exclude args (works on Git Bash if rsync is installed)
EXCLUDE_ARGS=()
for x in "${EXCLUDES[@]}"; do
  EXCLUDE_ARGS+=(--exclude="$x")
done

# Copy using rsync if available (cleanest); otherwise cp + cleanup
if command -v rsync &>/dev/null; then
  echo "Copying files (rsync, excluding week2 and build artifacts) ..."
  rsync -a "${EXCLUDE_ARGS[@]}" \
    --exclude="AI-ML-Projects-push" \
    --exclude="scripts/push-to-ai-ml-repo.sh" \
    "$SRC_ROOT/" "$DEST/"
else
  echo "rsync not found; using cp and then removing excluded paths ..."
  # Copy top-level dirs we want (excluding week2)
  for dir in backend frontend memory scripts terraform; do
    [ -d "$SRC_ROOT/$dir" ] && cp -R "$SRC_ROOT/$dir" "$DEST/"
  done
  # Copy root files (if any)
  for f in README.md LICENSE .gitignore; do
    [ -f "$SRC_ROOT/$f" ] && cp "$SRC_ROOT/$f" "$DEST/" 2>/dev/null || true
  done
  # Remove excluded dirs/files from destination
  (cd "$DEST" && rm -rf week2 .git node_modules .next out .venv __pycache__ lambda-package 2>/dev/null; true)
  (cd "$DEST/backend" 2>/dev/null && rm -rf .venv __pycache__ lambda-package .env lambda-deployment.zip 2>/dev/null; true)
  (cd "$DEST/frontend" 2>/dev/null && rm -rf .git node_modules .next out .env.production 2>/dev/null; true)
  (cd "$DEST/terraform" 2>/dev/null && rm -rf .terraform .terraform.lock.hcl 2>/dev/null; true)
fi

# Ensure we don't push backend/frontend .env, week2, or Terraform providers (>100MB)
rm -rf "$DEST/week2" 2>/dev/null || true
rm -rf "$DEST/terraform/.terraform" 2>/dev/null || true
rm -f "$DEST/backend/.env" "$DEST/frontend/.env.production" 2>/dev/null || true

echo "Contents in $SUBDIR:"
ls -la "$DEST"

# Commit and push
cd "$CLONE_DIR"
if [ -n "$(git status --porcelain "$SUBDIR")" ]; then
  git add "$SUBDIR"
  git commit -m "Add or update MLOps-resume-chatbot (excludes week2)"
  echo ""
  echo "Pushing to origin main ..."
  git push origin main
  echo "Done. View at: https://github.com/yuantian94/AI-ML-Projects"
else
  echo "No changes in $SUBDIR; nothing to push."
fi

echo ""
echo "Optional: remove clone with: rm -rf $CLONE_DIR"
