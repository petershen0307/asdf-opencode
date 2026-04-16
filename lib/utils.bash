#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/anomalyco/opencode"
TOOL_NAME="opencode"
TOOL_TEST="opencode --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

get_platform() {
	local platform
	platform="$(uname -s)"
	case "$platform" in
	Linux) echo "linux" ;;
	Darwin) echo "darwin" ;;
	*) fail "Unsupported platform: $platform" ;;
	esac
}

get_arch() {
	local arch
	arch="$(uname -m)"
	case "$arch" in
	x86_64) echo "x64" ;;
	aarch64 | arm64) echo "arm64" ;;
	*) fail "Unsupported architecture: $arch" ;;
	esac
}

get_ext() {
	local platform="$1"
	case "$platform" in
	linux) echo "tar.gz" ;;
	darwin) echo "zip" ;;
	*) fail "Unsupported platform: $platform" ;;
	esac
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

resolve_version() {
	local version="$1"
	if [ "$version" = "latest" ]; then
		version="$(list_all_versions | sort_versions | tail -n1 | xargs echo)"
	fi
	if [ -z "$version" ]; then
		fail "Could not resolve version"
	fi
	printf "%s" "$version"
}

download_release() {
	local version filename url platform arch ext
	version="$(resolve_version "$1")"
	filename="$2"
	platform="$(get_platform)"
	arch="$(get_arch)"
	ext="$(get_ext "$platform")"

	url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-${platform}-${arch}.${ext}"

	echo "* Downloading $TOOL_NAME release $version ($platform-$arch)..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
