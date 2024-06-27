#!/usr/bin/env bash

set -euo pipefail

GH_REPO="http://github.com/matter-labs/zksolc-bin"
TOOL_NAME="zksolc"
TOOL_TEST="zksolc --version"
case $(uname -s) in
    'Linux')
        OS="linux-amd64-musl"
        ;;
    'Darwin')
        OS="macosx-arm64"
        ;;
esac

fail() {
    echo -e "asdf-$TOOL_NAME: $*"
    exit 1
}

curl_opts=(-fsSL)

sort_versions() {
    sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
        LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
    git ls-remote --tags --refs "$GH_REPO" | cut -d/ -f3- | grep -oE '[0-9]+\.[0-9]+\.[0-9]+$'
}

list_all_versions() {
    list_github_tags
}

download_release() {
    local version filename url
    version="$1"
    filename="$2"

    url="$GH_REPO/releases/download/v${version}/zksolc-$OS-v${version}"

    echo "* Downloading $TOOL_NAME release $version..."
    curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
    local install_type="$1"
    local version="$2"
    local install_path="$3"

    if [ "$install_type" != "version" ]; then
        fail "asdf-$TOOL_NAME supports release installs only"
    fi

    (
        mkdir -p "$install_path/bin"
        local tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
        local bin_file="$install_path/bin/$tool_cmd"

        download_release "$version" "$bin_file"
        chmod a+x "$install_path/bin/$tool_cmd" || fail "Could not chmod +x $install_path/bin/$tool_cmd."

        test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

        echo "$TOOL_NAME $version installation was successful!"
    ) || (
        rm -rf "$install_path"
        fail "An error occurred while installing $TOOL_NAME $version."
    )
}
