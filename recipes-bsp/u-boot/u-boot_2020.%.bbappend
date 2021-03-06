FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS_append = " u-boot-tools-native"

SRC_URI_append_mpfs = " \
            file://${UBOOT_ENV}.txt \
            file://mpfs_defconfig\
           "
SRC_URI_append_lc-mpfs = " \
            file://${UBOOT_ENV}.txt \
            file://mpfs_defconfig\
           "

SRC_URI_append_icicle-kit-es = " \
            file://${UBOOT_ENV}.txt \
            file://mpfs_icicle.dts \
            file://0001-defconfig-for-the-Microchip-mpfs-icicle-SoC-board.patch \
	    file://0002-include-configs-for-the-Microchip-mpfs-icicle-kit.patch \
	    file://0003-device-tree-for-the-Microchip-mpfs-icicle-kit.patch \
	    file://0004-board-specific-code-for-the-Microchip-mpfs-icicle-ki.patch \
	    file://0005-gem-driver-for-the-Microchip-mpfs-icicle-kit.patch \
           "

SRC_URI_append_icicle-kit-es-sd = " \
            file://mpfs_icicle.dts \
            file://${UBOOT_ENV}.txt \
            file://0001-defconfig-for-the-Microchip-mpfs-icicle-SoC-board.patch \
	    file://0002-include-configs-for-the-Microchip-mpfs-icicle-kit.patch \
	    file://0003-device-tree-for-the-Microchip-mpfs-icicle-kit.patch \
	    file://0004-board-specific-code-for-the-Microchip-mpfs-icicle-ki.patch \
	    file://0005-gem-driver-for-the-Microchip-mpfs-icicle-kit.patch \
           "
# Overwrite this for your server
TFTP_SERVER_IP ?= "127.0.0.1"

do_configure_prepend_mpfs() {
    cp -f ${WORKDIR}/mpfs_defconfig ${S}/configs
    sed -i -e 's,@SERVERIP@,${TFTP_SERVER_IP},g' ${WORKDIR}/${UBOOT_ENV}.txt

    if [ -f "${WORKDIR}/${UBOOT_ENV}.txt" ]; then
        mkimage -O linux -T script -C none -n "U-Boot boot script" \
            -d ${WORKDIR}/${UBOOT_ENV}.txt ${WORKDIR}/boot.scr.uimg
    fi
}

do_configure_prepend_lc-mpfs() {
    cp -f ${WORKDIR}/mpfs_defconfig ${S}/configs
    sed -i -e 's,@SERVERIP@,${TFTP_SERVER_IP},g' ${WORKDIR}/${UBOOT_ENV}.txt

    if [ -f "${WORKDIR}/${UBOOT_ENV}.txt" ]; then
        mkimage -O linux -T script -C none -n "U-Boot boot script" \
            -d ${WORKDIR}/${UBOOT_ENV}.txt ${WORKDIR}/boot.scr.uimg
    fi
}

do_configure_prepend_icicle-kit-es() {
    cp -f ${WORKDIR}/mpfs_icicle.dts ${S}/arch/riscv/dts
    sed -i -e 's,@SERVERIP@,${TFTP_SERVER_IP},g' ${WORKDIR}/${UBOOT_ENV}.txt
    if [ -f "${WORKDIR}/${UBOOT_ENV}.txt" ]; then
        mkimage -O linux -T script -C none -n "U-Boot boot script" \
            -d ${WORKDIR}/${UBOOT_ENV}.txt ${WORKDIR}/boot.scr.uimg
    fi
}

do_configure_prepend_icicle-kit-es-sd() {
    cp -f ${WORKDIR}/mpfs_icicle.dts ${S}/arch/riscv/dts
    sed -i -e 's,@SERVERIP@,${TFTP_SERVER_IP},g' ${WORKDIR}/${UBOOT_ENV}.txt
    if [ -f "${WORKDIR}/${UBOOT_ENV}.txt" ]; then
        mkimage -O linux -T script -C none -n "U-Boot boot script" \
            -d ${WORKDIR}/${UBOOT_ENV}.txt ${WORKDIR}/boot.scr.uimg
    fi
}

do_deploy_append_mpfs() {
    install -d ${DEPLOY_DIR_IMAGE}
    install -m 755 ${WORKDIR}/boot.scr.uimg ${DEPLOY_DIR_IMAGE}
}
do_deploy_append_lc-mpfs() {
    install -d ${DEPLOY_DIR_IMAGE}
    install -m 755 ${WORKDIR}/boot.scr.uimg ${DEPLOY_DIR_IMAGE}
}
do_deploy_append_icicle-kit-es-sd() {
    install -d ${DEPLOY_DIR_IMAGE}
    install -m 755 ${WORKDIR}/boot.scr.uimg ${DEPLOY_DIR_IMAGE}
}
do_deploy_append_icicle-kit-es() {
    install -d ${DEPLOY_DIR_IMAGE}
    install -m 755 ${WORKDIR}/boot.scr.uimg ${DEPLOY_DIR_IMAGE}
}

FILES_${PN}_append = " /boot/boot.scr.uimg"
