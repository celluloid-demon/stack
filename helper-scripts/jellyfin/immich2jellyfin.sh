#!/usr/bin/env bash
#
# jellyfin-sync.sh
#
#   A lightweight, idempotent sync/convert script.
#
# Usage:
#   jellyfin-sync.sh /path/to/source /path/to/destination
#
# Dependencies (at least one of):
#   - heif-convert  (from libheif)
#   - magick convert (ImageMagick 7+)
#
# The script will:
#   • Recreate the source directory tree under the destination.
#   • Convert HEIC/HEIF photos to JPEG.
#   • Hard‑link non‑HEIC files into the destination.
#
# It will skip any file that already exists in the destination
# – running the script again is safe and quick.

set -euo pipefail

# -----------------------------------------
# 1️⃣ Sanity / argument handling
# -----------------------------------------

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/source /path/to/destination" >&2
    exit 1
fi

SRC_DIR="${1%/}"   # strip trailing slash
DEST_DIR="${2%/}"  # strip trailing slash

if [[ ! -d "$SRC_DIR" ]]; then
    echo "❌ Source directory '$SRC_DIR' does not exist." >&2
    exit 1
fi

# mkdir -p "$DEST_DIR"
if [[ ! -d "$DEST_DIR" ]]; then
    echo "❌ Destination directory '$DEST_DIR' does not exist." >&2
    exit 1
fi

# -----------------------------------------
# 2️⃣ Pick a HEIC conversion tool
# -----------------------------------------

if command -v heif-convert >/dev/null; then
    CONVERTER="heif-convert"
elif command -v magick >/dev/null; then
    CONVERTER="magick"
else
    echo "❌ No HEIC converter found. Install libheif (heif-convert) or ImageMagick (magick)." >&2
    exit 1
fi

echo "✅ Using converter: $CONVERTER"

# -----------------------------------------
# 3️⃣ Walk the source tree
# -----------------------------------------

# find … -printf "%P\n" gives us the path *relative to* SRC_DIR
# (e.g. photos/2024/01/img-001.heic)
find "$SRC_DIR" -type f -printf "%P\n" | while IFS= read -r rel_path; do
    src_file="$SRC_DIR/$rel_path"

    # Destination path: same relative path, but .jpg extension if needed
    case "${rel_path##*.}" in
        heic|heif)
            dest_rel="${rel_path%.*}.jpg"
            ;;
        *)
            dest_rel="$rel_path"
            ;;
    esac
    dest_file="$DEST_DIR/$dest_rel"
    dest_dir="$(dirname "$dest_file")"

    # Ensure the destination folder exists
    mkdir -p "$dest_dir"

    # -----------------------------------------
    # 4️⃣ Decide what to do
    # -----------------------------------------

    if [ -f "$dest_file" ]; then
        # File already exists – skip to keep idempotent
        echo "⏩ Skipping (already present): $dest_rel"
        continue
    fi

    case "${rel_path##*.}" in
        heic|heif)
            echo "🔄 Converting: $rel_path → ${dest_rel}"
            if [ "$CONVERTER" = "heif-convert" ]; then
                heif-convert "$src_file" "$dest_file"
            else
                # ImageMagick 7+
                magick "$src_file" -quality 100 "$dest_file"
            fi
            ;;
        *)
            echo "🔗 Linking: $rel_path → ${dest_rel}"
            ln "$src_file" "$dest_file"
            ;;
    esac
done

# ------------------------------------------------------------------
# 5️⃣ Clean up orphaned files in destination
# ------------------------------------------------------------------

echo "🧹 Cleaning up orphaned files in destination..."

# Temporary files to hold expected and found lists
tmp_expected=$(mktemp)
tmp_found=$(mktemp)

# ---- Build expected list -------------------------------------------------
# For each source file, compute the relative path that should exist in
# the destination (HEIC → .jpg, others unchanged)
find "$SRC_DIR" -type f -printf "%P\n" | while IFS= read -r rel; do
    case "${rel##*.}" in
        heic|heif)
            echo "${rel%.*}.jpg"
            ;;
        *)
            echo "$rel"
            ;;
    esac
done > "$tmp_expected"

# ---- Build found list ----------------------------------------------------
# List all files currently in the destination (relative paths)
find "$DEST_DIR" -type f -printf "%P\n" > "$tmp_found"

# Sort the lists – required for comm
sort -u "$tmp_expected" -o "$tmp_expected"
sort -u "$tmp_found"   -o "$tmp_found"

# ---- Delete files that exist in DEST but not in expected ----------------
# comm -23 prints lines that are in the first file but not the second
comm -23 "$tmp_found" "$tmp_expected" | while IFS= read -r orphan_rel; do
    orphan_path="$DEST_DIR/$orphan_rel"
    echo "❌ Deleting orphaned file: $orphan_rel"
    rm -f "$orphan_path"
done

# ---- Remove any empty directories left behind ---------------------------
find "$DEST_DIR" -type d -empty -delete

# Clean up temporary files
rm -f "$tmp_expected" "$tmp_found"

echo "✅ Done! All files now exist in $DEST_DIR"
