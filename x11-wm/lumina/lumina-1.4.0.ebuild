# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="af ar az bg bn bs ca cs cy da de el en_AU en_GB en_ZA es et eu fa fi fr fr_CA fur gl he hi hr hu id is it ja ka ko lt lv mk mn ms mt nb ne nl pa pl pt pt_BR ro ru sa sk sl sr sv sw ta tg th tr uk ur uz vi zh_CN zh_HK zh_TW zu"

inherit qmake-utils xdg-utils l10n
DESCRIPTION="Lumina desktop environment"
HOMEPAGE="https://lumina-desktop.org/"
SRC_URI="https://github.com/trueos/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="desktop-utils"

COMMON_DEPEND="dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtsvg:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	x11-libs/libxcb:0
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	desktop-utils? ( app-text/poppler[qt5] )"

DEPEND="$COMMON_DEPEND
	dev-qt/linguist-tools:5"

RDEPEND="$COMMON_DEPEND
	sys-fs/inotify-tools
	x11-misc/numlockx
	x11-wm/fluxbox
	|| ( x11-apps/xbacklight
	sys-power/acpilight )
	media-sound/alsa-utils
	sys-power/acpi
	app-admin/sysstat"

S="${WORKDIR}/${P/_/-}"

PATCHES=(
	"${FILESDIR}/1.2.0-desktop-files.patch"
	"${FILESDIR}/1.3.0-OS-detect.patch"
	"${FILESDIR}/1.4.0-poppler.patch"
)

DOCS=( README.md )

src_prepare(){
	default

	if use !desktop-utils ; then
		rm -rf src-qt5/desktop-utils || die
		sed -e "/desktop-utils/d" -i src-qt5/src-qt5.pro || die
	fi

	l10n_find_plocales_changes "${S}/src-qt5/core/${PN}-desktop/i18n" "${PN}-desktop_" '.ts'
}

src_configure(){
	eqmake5 PREFIX="${EPREFIX}/usr" LIBPREFIX="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" CONFIG+=WITH_I18N QMAKE_CFLAGS_ISYSTEM=
}

src_install(){
	# some minor hack. don't bother.
	emake INSTALL_ROOT="${D}" install || die

	mv "${D}/${D}"/usr/bin/ "${D}"/usr/bin/ || die
	mv "${D}/${D}"/usr/share/ "${D}"/usr/share/ || die
	mv "${D}/${D}"/etc/ "${D}"/etc/ || die

	einstalldocs

	#cleaning sequence
	remove_locale() {
		rm -f "${D}"/usr/share/${PN}-desktop/i18n/l*_${1}.qm
	}
	l10n_for_each_disabled_locale_do remove_locale

	if [[ -e "${ED%/}"/lumina ]] ; then
		rm "${ED%/}"/${PN}* || die
		rm "${ED%/}"/${PN}-* || die
	fi
	rm "${ED%/}"/lthemeengine* || die
	rm "${ED%/}"/liblthemeengine*.so || die
	rm -rf "${D}"/var/ || die

	mv "${ED%/}"/etc/luminaDesktop.conf{.dist,} || die
	rm "${ED%/}"/${PN}-* "${ED%/}"/start-${PN}-desktop || die
}

pkg_postinst(){
	# qt5 doesn't help us much here.
	xdg_desktop_database_update || die
}

pkg_postrm(){
	# qt5 doesn't help us here either
	xdg_desktop_database_update || die
}
