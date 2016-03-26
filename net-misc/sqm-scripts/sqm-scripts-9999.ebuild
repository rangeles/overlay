# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="SQM scripts traffic shaper"
HOMEPAGE="https://github.com/tohojo/sqm-scripts#readme"

EGIT_REPO_URI="https://github.com/tohojo/sqm-scripts.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	net-firewall/iptables
	sys-apps/iproute2
	sys-apps/kmod"

# TODO we still need to run kernel configuration checks

src_install() {
	emake DESTDIR="${D}" install-linux

	insinto /etc/sqm
	doins "${FILEDIR}/eth0.iface.conf.example"

	doinitd "${FILESDIR}/sqm.eth0"
}
