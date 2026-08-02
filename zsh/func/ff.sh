# open files in Firefox (new tab, file:// URL)
ff() {
  for f in "$@"; do
    firefox --new-tab "file://$(realpath "$f")"
  done
}
