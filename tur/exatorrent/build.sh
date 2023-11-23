TERMUX_PKG_HOMEPAGE=https://github.com/varbhat/exatorrent
TERMUX_PKG_DESCRIPTION="Self-hostable, easy-to-use, lightweight, and feature-rich torrent client written in Go"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION="1.2.1"
TERMUX_PKG_SRCURL=https://github.com/varbhat/exatorrent/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c3e4a95d0ba5e1eb17d27b44a5b2520baae73af474460be3e3e6fdfd815bfae3
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_nodejs

	cp -r $TERMUX_PKG_SRCDIR/internal/web ./web
	cd web
	npm install
	npm run build
}

termux_step_pre_configure() {
	cp -r $TERMUX_PKG_HOSTBUILD_DIR/web/build $TERMUX_PKG_SRCDIR/internal/web/

	termux_setup_golang
}

termux_step_make() {
	go build -trimpath -buildmode=pie -ldflags '-extldflags "-s -w -Wl,--allow-multiple-definition"' -o build/exatorrent exatorrent.go
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/build/exatorrent
}
