# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XLIBRE_DRI=always

inherit linux-info xlibre

if [[ ${PV} != 9999* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="ATI video driver"
HOMEPAGE="https://github.com/X11Libre/xf86-video-ati"

IUSE="udev"

RDEPEND="
	media-libs/mesa
	>=x11-libs/libdrm-2.4.89[video_cards_radeon]
	>=x11-libs/libpciaccess-0.8.0
	x11-base/xlibre-server[-minimal]
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

pkg_pretend() {
	if use kernel_linux; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

pkg_setup() {
	linux-info_pkg_setup
	xlibre_pkg_setup
}

src_configure() {
	local XLIBRE_CONFIGURE_OPTIONS=(
		--enable-glamor
		$(use_enable udev)
	)
	xlibre_src_configure
}
