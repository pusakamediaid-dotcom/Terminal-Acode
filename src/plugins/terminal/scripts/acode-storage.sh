#!/bin/sh
# Diagnose actual filesystem access, not the synthetic root identity in PRoot.
set -u

usage() {
    cat <<'HELP'
Usage: acode-storage [status | check PATH | help]

status      Report common workspace and Android storage paths (default).
check PATH  Check a directory without creating, deleting, or changing files.

PRoot root is not Android root. Bind mounts do not grant Android permissions.
A readable directory is not a guarantee that every child file is accessible.
A writable permission check is not a guarantee that a write will succeed.
SAF content:// grants in the editor are not ordinary shell filesystem paths.
Android/data and Android/obb may remain restricted, even with broad storage access.
Use the editor's folder picker for supported document access. Keep executable
projects in /home; shared storage may not support Linux executable permissions.
HELP
}

check_dir() {
    path=$1
    printf '\nPath: %s\n' "$path"
    case "$path" in
        content://*)
            printf 'SAF URI: not a filesystem path; use the editor folder picker.\n'
            return 1 ;;
    esac
    if [ ! -d "$path" ]; then
        printf 'Directory missing or not visible to this app.\n'
        return 1
    fi
    if [ -r "$path" ] && [ -x "$path" ] && ls -a -- "$path" >/dev/null 2>&1; then
        printf 'Directory listing: accessible\n'
    else
        printf 'Directory listing: denied or unavailable\n'
        return 1
    fi
    if [ -w "$path" ]; then
        printf 'Write permission check: yes (no write attempted)\n'
    else
        printf 'Write permission check: no\n'
    fi
}

case "${1:-status}" in
    status)
        [ "$#" -le 1 ] || { usage >&2; exit 2; }
        usage
        for location in /home /sdcard /storage/emulated/0 /storage/emulated/0/Download /storage/emulated/0/Android/data /storage/emulated/0/Android/obb; do
            check_dir "$location" || :
        done
        ;;
    check)
        [ "$#" -eq 2 ] && [ -n "$2" ] || { usage >&2; exit 2; }
        check_dir "$2"
        ;;
    help|--help|-h) usage ;;
    *) usage >&2; exit 2 ;;
esac
