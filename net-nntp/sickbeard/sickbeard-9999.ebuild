# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"

inherit eutils git python

MY_PN="${PN/s/S}"
MY_PN="${MY_PN/b/B}"

DESCRIPTION="PVR application that downloads and manages your TV shows"
HOMEPAGE="http://sickbeard.com"

EGIT_REPO_URI="https://github.com/midgetspy/Sick-Beard.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/cherrypy
	dev-python/cheetah"

DOCS=( "COPYING.txt" "readme.md" )

pkg_setup() {
    #Create sickbeard user/group
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 "${HOMEDIR}" "${PN}"
}

src_install() {
	# Init script
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	# Install
	dodir /var/lib/${PN}
	insinto /var/lib/${PN}

	for sickb_dir in autoProcessTV data lib sickbeard ; do
		doins -r ${sickb_dir} || die "failed to install ${sickb_dir}"
	done
	doins SickBeard.py || die "failed to install SickBeard.py"

	# Create run, log & cache directories
	for sickb_runtime_dir in run log cache ; do
		keepdir /var/${sickb_runtime_dir}/${PN}
		fowners -R ${PN}:${PN} /var/${sickb_runtime_dir}/${PN}
		fperms -R 775 /var/${sickb_runtime_dir}/${PN}
	done

	# Install bare-bone config file (NOTE: AFAICT, sickbeard will *always* look for it in its basedir...)
	insinto /etc/${PN}
	newins "${FILESDIR}/config.ini" "${PN}.ini"
	fowners root:${PN} /etc/${PN}/${PN}.ini
	fperms 660 /etc/${PN}/${PN}.ini

	# Fix perms
	fowners -R root:${PN} /var/lib/${PN}
	fperms -R 775 /var/lib/${PN}
}
