# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils qmake-utils

DESCRIPTION="Qt5 Configuration Tool"
HOMEPAGE="https://sourceforge.net/projects/qt5ct/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	>=dev-qt/linguist-tools-5.4.0:5
	>=dev-qt/qtcore-5.4.0:5
	>=dev-qt/qtsvg-5.4.0:5
"

RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${P}"

src_configure(){
	local myeqmakeargs=(
		${PN}.pro
		PREFIX="${EPREFIX}/usr"
		DESKTOPDIR="${EPREFIX}/usr/share/applications"
		ICONDIR="${EPREFIX}/usr/share/pixmaps"
	)
	eqmake5 ${myeqmakeargs[@]}
}

src_install(){
	emake INSTALL_ROOT="${ED}" install || die
}

pkg_postinst(){
	elog "After install this package, please, add the following"
	elog "line into the ~/.xprofile (user) or /etc/environment (system):"
	elog "export QT_QPA_PLATFORMTHEME=qt5ct"
	elog "and it will work."
}
