SUMMARY = "Microchip Polarfire SoC Hart Software Services (HSS) Payload Generator"
DESCRIPTION = "HSS requires U-Boot to be packaged with header details applied with hss payload generator"

LICENSE = "MIT & BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=2dc9e752dd76827e3a4eebfd5b3c6226"

inherit deploy
# Strict dependency
do_configure[depends] += "u-boot:do_deploy"


PV = "1.0+git${SRCPV}"
BRANCH = "master"
SRCREV="76b34dd0212425f9848eed41575db22cd829cecb"
SRC_URI = "git://github.com/polarfire-soc/hart-software-services.git;branch=${BRANCH} \
           file://uboot.yaml \
           file://0001-hss-payload-generator-link-libraries-without-static-.patch \
          "

S = "${WORKDIR}/git"


EXTRA_OEMAKE += 'HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}"'

# NOTE: Only using the Payload generator from the HSS


do_configure () {
	## taking U-Boot binary and package for HSS
	cp -f ${DEPLOY_DIR_IMAGE}/u-boot.bin ${WORKDIR}/git/
	cp -f ${WORKDIR}/uboot.yaml ${WORKDIR}/git/tools/hss-payload-generator/
}


do_compile () {

	## Adding u-boot as a payload
	## Using hss-payload-generator application
	make -C ${WORKDIR}/git/tools/hss-payload-generator
	${WORKDIR}/git/tools/hss-payload-generator/hss-payload-generator -c ${WORKDIR}/git/tools/hss-payload-generator/uboot.yaml -v payload.bin
}

do_install() {
	install -d ${DEPLOY_DIR_IMAGE}
	install -m 755 ${WORKDIR}/git/payload.bin ${DEPLOY_DIR_IMAGE}/
}
