# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils

DESCRIPTION="A Qt-based interface to system statistics"
HOMEPAGE="http://lxqt.org/"

SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
KEYWORDS="amd64"

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="
	dev-qt/qtcore:5
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"
