WEBDIR = /var/www/reilly/folding
CGIDIR = /usr/lib/cgi-bin
LOOPDEV = $(shell sudo losetup -f)
MOUNT = /mnt

# Program Versions
KERNEL_VERSION = 4.2.3
GLIBC_VERSION = 2.21
BUSYBOX_VERSION = 1.23.2
SYSLINUX_VERSION = 6.03
BZIP_VERSION = 1.0.6
CDRKIT_VERSION = 1.1.11
GCC_VERSION = 4.9.2
OPENSSL_VERSION=1.0.2
OPENSSL_PATCH_LEVEL=d
ZLIB_VERSION=1.2.8
WGET_VERSION=1.16.1

all : folding_cd.iso diskless.zip usb.zip

.PHONY : prefetch distclean clean install_net install_web

distclean: clean
	-rm -rf linux-$(KERNEL_VERSION).tar.xz glibc-$(GLIBC_VERSION).tar.xz busybox-$(BUSYBOX_VERSION).tar.bz2 syslinux-$(SYSLINUX_VERSION).tar.xz bzip2-$(BZIP_VERSION).tar.gz cdrkit-$(CDRKIT_VERSION).tar.gz gcc-$(GCC_VERSION).tar.bz2 zlib-$(ZLIB_VERSION).tar.gz openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL).tar.gz wget-$(WGET_VERSION).tar.xz

clean:
	-rm -rf linux-$(KERNEL_VERSION) glibc glibc_libs glibc-$(GLIBC_VERSION) glibc_src busybox-$(BUSYBOX_VERSION) syslinux-$(SYSLINUX_VERSION) syslinux_src bzip2-$(BZIP_VERSION) boot initrd_dir/lib initrd_dir/lib64 initrd_dir/bin/busybox initrd_dir/bin/encode initrd_dir/bin/isVMWare initrd_dir/bin/isVPC initrd_dir/bin/queueinfo initrd_dir/bin/mbr.bin initrd_dir/bin/syslinux initrd_dir/bin/isolinux.bin initrd_dir/etc/folding/cgi-bin/kernel initrd_dir/bin/genisoimage initrd_dir/etc/manifest initrd_dir/etc/folding/cgi-bin/fold.txt initrd_dir/etc/folding/cgi-bin/index.cgi diskless diskless.zip usb.zip kernel_patch folding_cd.iso folding.zip partition_table part_gen outfile disk folding cdrkit-$(CDRKIT_VERSION) gcc_source gcc-$(GCC_VERSION) initrd_dir/etc/folding/cgi-bin/isolinux.bin kernel_firmware initrd_dir/lib/firmware boot/ldlinux.c32 diskless/ldlinux.c32 initrd_dir/etc/folding/cgi-bin/ldlinux.c32 initrd_dir/include zlib_source zlib-$(ZLIB_VERSION) openssl_source openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL) wget_source wget-$(WGET_VERSION) initrd_dir/bin/wget

### install_web ###
install_web: $(WEBDIR)/benchmark.html $(WEBDIR)/cd.html $(WEBDIR)/diskless.html $(WEBDIR)/diskless.zip $(WEBDIR)/index.html $(WEBDIR)/linux.html $(WEBDIR)/syslinux $(WEBDIR)/syslinux.com $(WEBDIR)/syslinux.exe $(WEBDIR)/usb.html $(WEBDIR)/usb.zip $(WEBDIR)/folding.zip $(WEBDIR)/vm.html $(CGIDIR)/fold.iso $(CGIDIR)/kernel $(CGIDIR)/initrd $(CGIDIR)/isolinux.bin $(CGIDIR)/fold.txt

$(WEBDIR)/folding.zip : folding.zip
	mkdir -p $(WEBDIR)
	cp folding.zip $(WEBDIR)

$(WEBDIR)/diskless.zip : diskless.zip
	mkdir -p $(WEBDIR)
	cp diskless.zip $(WEBDIR)

$(WEBDIR)/index.html : web/index.html
	mkdir -p $(WEBDIR)
	cp web/index.html $(WEBDIR)

$(WEBDIR)/syslinux : initrd_dir/bin/syslinux
	mkdir -p $(WEBDIR)
	cp initrd_dir/bin/syslinux $(WEBDIR)

$(WEBDIR)/syslinux.com : diskless/syslinux.com
	mkdir -p $(WEBDIR)
	cp diskless/syslinux.com $(WEBDIR)

$(WEBDIR)/syslinux.exe : diskless/syslinux.exe
	mkdir -p $(WEBDIR)
	cp diskless/syslinux.exe $(WEBDIR)

$(WEBDIR)/usb.zip : usb.zip
	mkdir -p $(WEBDIR)
	cp usb.zip $(WEBDIR)

$(CGIDIR)/fold.iso : folding_cd.iso
	sudo mkdir -p $(CGIDIR)
	sudo cp folding_cd.iso $(CGIDIR)/fold.iso

$(CGIDIR)/kernel : boot/kernel
	sudo mkdir -p $(CGIDIR)
	sudo cp boot/kernel $(CGIDIR)

$(CGIDIR)/initrd : boot/initrd
	sudo mkdir -p $(CGIDIR)
	sudo cp boot/initrd $(CGIDIR)

$(CGIDIR)/isolinux.bin : boot/isolinux.bin
	sudo mkdir -p $(CGIDIR)
	sudo cp boot/isolinux.bin $(CGIDIR)

$(CGIDIR)/fold.txt : boot/fold.txt
	sudo mkdir -p $(CGIDIR)
	sudo cp boot/fold.txt $(CGIDIR)

$(WEBDIR)/benchmark.html : web/benchmark.html
	mkdir -p $(WEBDIR)
	cp web/benchmark.html $(WEBDIR)

$(WEBDIR)/vm.html : NEWS web/vm.html
	mkdir -p $(WEBDIR)
	cat web/vm.html > $(WEBDIR)/vm.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/vm.html && \
	echo "</body>" >> $(WEBDIR)/vm.html && \
	echo "</html>" >> $(WEBDIR)/vm.html

$(WEBDIR)/cd.html : NEWS web/cd.html
	mkdir -p $(WEBDIR)
	cat web/cd.html > $(WEBDIR)/cd.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/cd.html && \
	echo "</body>" >> $(WEBDIR)/cd.html && \
	echo "</html>" >> $(WEBDIR)/cd.html

$(WEBDIR)/usb.html : NEWS web/usb.html
	mkdir -p $(WEBDIR)
	cat web/usb.html > $(WEBDIR)/usb.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/usb.html && \
	echo "</body>" >> $(WEBDIR)/usb.html && \
	echo "</html>" >> $(WEBDIR)/usb.html

$(WEBDIR)/linux.html : NEWS web/linux.html
	mkdir -p $(WEBDIR)
	cat web/linux.html > $(WEBDIR)/linux.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/linux.html && \
	echo "</body>" >> $(WEBDIR)/linux.html && \
	echo "</html>" >> $(WEBDIR)/linux.html

$(WEBDIR)/diskless.html : NEWS web/diskless.html
	mkdir -p $(WEBDIR)
	cat web/diskless.html > $(WEBDIR)/diskless.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/diskless.html && \
	echo "</body>" >> $(WEBDIR)/diskless.html && \
	echo "</html>" >> $(WEBDIR)/diskless.html


### install_net ###
install_net: /var/lib/tftpboot/PXEClient/kernel /var/lib/tftpboot/PXEClient/initrd /var/lib/tftpboot/PXEClient/pxelinux.cfg/default /var/lib/tftpboot/PXEClient/pxelinux.0 /var/lib/tftpboot/PXEClient/fold.txt

/var/lib/tftpboot/PXEClient/kernel : boot/kernel
	mkdir -p /var/lib/tftpboot/PXEClient
	cp boot/kernel /var/lib/tftpboot/PXEClient/kernel

/var/lib/tftpboot/PXEClient/initrd : boot/initrd
	mkdir -p /var/lib/tftpboot/PXEClient
	cp boot/initrd /var/lib/tftpboot/PXEClient/initrd

/var/lib/tftpboot/PXEClient/pxelinux.cfg/default : boot/isolinux.cfg
	mkdir -p /var/lib/tftpboot/PXEClient/pxelinux.cfg
	cp boot/isolinux.cfg /var/lib/tftpboot/PXEClient/pxelinux.cfg/default

/var/lib/tftpboot/PXEClient/pxelinux.0 : diskless/pxelinux.0
	mkdir -p /var/lib/tftpboot/PXEClient
	cp diskless/pxelinux.0 /var/lib/tftpboot/PXEClient/pxelinux.0

/var/lib/tftpboot/PXEClient/fold.txt : boot/fold.txt
	mkdir -p /var/lib/tftpboot/PXEClient
	cp boot/fold.txt /var/lib/tftpboot/PXEClient/fold.txt

# Download source archives if required.
prefetch : linux-$(KERNEL_VERSION).tar.xz glibc-$(GLIBC_VERSION).tar.xz busybox-$(BUSYBOX_VERSION).tar.bz2 syslinux-$(SYSLINUX_VERSION).tar.xz bzip2-$(BZIP_VERSION).tar.gz cdrkit-$(CDRKIT_VERSION).tar.gz gcc-$(GCC_VERSION).tar.bz2 zlib-$(ZLIB_VERSION).tar.gz openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL).tar.gz wget-$(WGET_VERSION).tar.xz

linux-$(KERNEL_VERSION).tar.xz :
	wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-$(KERNEL_VERSION).tar.xz

glibc-$(GLIBC_VERSION).tar.xz :
	wget http://ftp.gnu.org/gnu/glibc/glibc-$(GLIBC_VERSION).tar.xz
	
busybox-$(BUSYBOX_VERSION).tar.bz2 :
	wget http://busybox.net/downloads/busybox-$(BUSYBOX_VERSION).tar.bz2

syslinux-$(SYSLINUX_VERSION).tar.xz :
	wget http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-$(SYSLINUX_VERSION).tar.xz

bzip2-$(BZIP_VERSION).tar.gz :
	wget http://www.bzip.org/$(BZIP_VERSION)/bzip2-$(BZIP_VERSION).tar.gz

cdrkit-$(CDRKIT_VERSION).tar.gz :
	wget http://distro.ibiblio.org/slitaz/sources/packages/c/cdrkit-$(CDRKIT_VERSION).tar.gz

gcc-$(GCC_VERSION).tar.bz2 :
	wget http://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)/gcc-$(GCC_VERSION).tar.bz2

zlib-$(ZLIB_VERSION).tar.gz :
	wget http://zlib.net/zlib-$(ZLIB_VERSION).tar.gz

openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL).tar.gz :
	wget https://www.openssl.org/source/openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL).tar.gz

wget-$(WGET_VERSION).tar.xz :
	wget http://ftp.gnu.org/gnu/wget/wget-$(WGET_VERSION).tar.xz

### diskless.zip ###
diskless.zip : diskless/kernel diskless/initrd diskless/pxelinux.cfg/default diskless/pxelinux.0 diskless/fold.txt
	mkdir -p diskless
	cd diskless && \
	zip -r ../diskless.zip kernel initrd pxelinux.0 pxelinux.cfg/default fold.txt

diskless/kernel : boot/kernel
	mkdir -p diskless
	cp boot/kernel diskless/kernel

diskless/initrd : boot/initrd
	mkdir -p diskless
	cp boot/initrd diskless/initrd

diskless/pxelinux.cfg/default : boot/isolinux.cfg
	mkdir -p diskless/pxelinux.cfg && \
	cp boot/isolinux.cfg diskless/pxelinux.cfg/default

diskless/fold.txt : boot/fold.txt
	cp boot/fold.txt diskless/fold.txt

### usb.zip ###
usb.zip : diskless/kernel diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt diskless/ldlinux.c32
	mkdir -p diskless
	cd diskless && \
	zip -r ../usb.zip kernel initrd syslinux.cfg ldlinux.c32 version.txt fold.txt

diskless/syslinux.cfg : boot/isolinux.cfg
	mkdir -p diskless
	cp boot/isolinux.cfg diskless/syslinux.cfg

diskless/version.txt : initrd_dir/init
	mkdir -p diskless
	grep -m 1 VERSION= initrd_dir/init | sed s/VERSION=// > diskless/version.txt

### folding.zip ###
folding.zip: disk diskless/kernel diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt initrd_dir/bin/syslinux folding/folding.vmx diskless/ldlinux.c32
	mkdir -p folding
	mkdir -p $(MOUNT)
	sudo losetup -o 32256 $(LOOPDEV) disk && \
	mkdosfs -F 32 $(LOOPDEV) && \
	sudo mount $(LOOPDEV) $(MOUNT) && \
	sudo cp diskless/ldlinux.c32 diskless/kernel diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt $(MOUNT) && \
	sudo umount $(MOUNT) && \
	sudo initrd_dir/bin/syslinux $(LOOPDEV) && \
	dosfsck -a $(LOOPDEV) ; \
        sudo losetup -d $(LOOPDEV) && \
	qemu-img convert disk -O vmdk folding.vmdk && \
        mv folding.vmdk folding && \
        zip folding.zip folding/folding.vmx folding/folding.vmdk

disk: initrd_dir/bin/mbr.bin partition_table
	dd if=/dev/zero of=outfile bs=1024 count=1048576 && \
	cat initrd_dir/bin/mbr.bin partition_table outfile > disk

partition_table: part_gen
	./part_gen > partition_table

part_gen: part_gen.c
	gcc -o part_gen part_gen.c

### folding_cd.iso ###
folding_cd.iso : boot/kernel boot/initrd boot/isolinux.bin boot/isolinux.cfg boot/fold.txt boot/ldlinux.c32
	cp boot/isolinux.bin boot/isolin.bin && \
	mkisofs -o folding_cd.iso -b isolin.bin -c boot.cat -no-emul-boot -boot-load-size 4 -input-charset utf-8 -boot-info-table boot && \
	rm boot/isolin.bin

boot/isolinux.cfg : patches/isolinux.cfg
	mkdir -p boot
	cp patches/isolinux.cfg boot

boot/fold.txt : patches/fold.txt
	mkdir -p boot
	cp patches/fold.txt boot

boot/ldlinux.c32: initrd_dir/bin/syslinux
	mkdir -p boot
	cp syslinux-$(SYSLINUX_VERSION)/bios/com32/elflink/ldlinux/ldlinux.c32 boot

diskless/ldlinux.c32: initrd_dir/bin/syslinux
	mkdir -p boot
	cp syslinux-$(SYSLINUX_VERSION)/bios/com32/elflink/ldlinux/ldlinux.c32 diskless

#### initrd ####
boot/initrd : initrd_dir/bin/isVMWare initrd_dir/bin/isVPC initrd_dir/bin/queueinfo initrd_dir/bin/busybox initrd_dir/bin/mbr.bin initrd_dir/bin/syslinux initrd_dir/etc/folding/cgi-bin/isolinux.bin initrd_dir/etc/folding/cgi-bin/kernel glibc_libs initrd_dir/init initrd_dir/bin/encode initrd_dir/bin/backup.sh initrd_dir/bin/check_hang.sh initrd_dir/bin/processor.awk initrd_dir/bin/average.awk initrd_dir/bin/bench.amber.awk initrd_dir/bin/bench.bonusgromacs.awk initrd_dir/bin/bench.gromacs33.awk initrd_dir/bin/bench.tinker.awk initrd_dir/bin/benchmark.sh initrd_dir/etc/folding/cgi-bin/index.cgi initrd_dir/etc/folding/cgi-bin/fold.txt initrd_dir/etc/folding/cgi-bin/reconf.cgi initrd_dir/etc/folding/cgi-bin/oneunit.cgi initrd_dir/lib64/libbz2.so.1 initrd_dir/lib64/libgcc_s.so.1 initrd_dir/lib64/libstdc++.so.6 initrd_dir/etc/folding/cgi-bin/fold.iso initrd_dir/bin/genisoimage kernel_firmware initrd_dir/etc/folding/cgi-bin/ldlinux.c32 boot/kernel initrd_dir/bin/wget
	mkdir -p initrd_dir/tmp
	cd initrd_dir && \
	chmod 1777 tmp && \
	find . -type d \( -name .svn -o -name include \) -prune -o -print > etc/manifest && \
	bin/busybox cpio -o -H newc < etc/manifest | gzip -9 > ../boot/initrd

initrd_dir/bin/queueinfo : glibc_libs queueinfo.c
	mkdir -p initrd_dir/bin
	gcc -L glibc -o initrd_dir/bin/queueinfo queueinfo.c -lc -lc_nonshared glibc/elf/ld.so

initrd_dir/bin/encode : glibc_libs encode.c
	mkdir -p initrd_dir/bin
	gcc -L glibc -o initrd_dir/bin/encode encode.c -lc -lc_nonshared glibc/elf/ld.so

initrd_dir/etc/folding/cgi-bin/ldlinux.c32: boot/ldlinux.c32
	cp boot/ldlinux.c32 initrd_dir/etc/folding/cgi-bin/ldlinux.c32

initrd_dir/etc/folding/cgi-bin/fold.txt : patches/fold.txt
	mkdir -p initrd_dir/etc/folding/cgi-bin
	cp patches/fold.txt initrd_dir/etc/folding/cgi-bin

initrd_dir/bin/genisoimage : glibc_libs cdrkit-$(CDRKIT_VERSION).tar.gz initrd_dir/lib64/libz.so.$(ZLIB_VERSION) 
	mkdir -p initrd_dir/bin
	tar xzf cdrkit-$(CDRKIT_VERSION).tar.gz
	cd cdrkit-$(CDRKIT_VERSION) && \
	patch -p1 < ../patches/cdrkit-1.1.11-cmakewarn.patch && \
	patch -p1 < ../patches/cdrkit-1.1.11-dvdman.patch && \
	patch -p1 < ../patches/cdrkit-1.1.11-format.patch && \
	patch -p1 < ../patches/cdrkit-1.1.11-handler.patch && \
	patch -p1 < ../patches/cdrkit-1.1.11-manpagefix.patch && \
	patch -p1 < ../patches/cdrkit-1.1.11-memset.patch && \
	patch -p1 < ../patches/cdrkit-1.1.11-readsegfault.patch && \
	patch -p1 < ../patches/cdrkit-1.1.11-rootstat.patch && \
	patch -p1 < ../patches/cdrkit-1.1.11-usalinst.patch
	LDFLAGS="-L$(CURDIR)/initrd_dir/lib64" CFLAGS="-I$(CURDIR)/zlib-$(ZLIB_VERSION) -I$(CURDIR)/openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL)/include" $(MAKE) -C cdrkit-$(CDRKIT_VERSION) build/Makefile
	LDFLAGS="-L$(CURDIR)/initrd_dir/lib64" CFLAGS="-I$(CURDIR)/zlib-$(ZLIB_VERSION) -I$(CURDIR)/openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL)/include" $(MAKE) -C cdrkit-$(CDRKIT_VERSION)/build genisoimage
	cp cdrkit-$(CDRKIT_VERSION)/build/genisoimage/genisoimage initrd_dir/bin/genisoimage

#### isolinux, pxelinux, syslinux ####
diskless/syslinux.exe : initrd_dir/bin/syslinux
	mkdir -p diskless
	cp syslinux-$(SYSLINUX_VERSION)/bios/win32/syslinux.exe diskless/syslinux.exe

diskless/syslinux.com : initrd_dir/bin/syslinux
	mkdir -p diskless
	cp syslinux-$(SYSLINUX_VERSION)/bios/dos/syslinux.com diskless/syslinux.com

initrd_dir/etc/folding/cgi-bin/isolinux.bin : boot/isolinux.bin
	mkdir -p initrd_dir/etc/folding/cgi-bin
	cp boot/isolinux.bin initrd_dir/etc/folding/cgi-bin/isolinux.bin

boot/isolinux.bin : initrd_dir/bin/syslinux
	mkdir -p boot
	cp syslinux-$(SYSLINUX_VERSION)/bios/core/isolinux.bin boot

diskless/pxelinux.0 : initrd_dir/bin/syslinux
	mkdir -p diskless
	cp syslinux-$(SYSLINUX_VERSION)/bios/core/pxelinux.0 diskless

initrd_dir/bin/mbr.bin : initrd_dir/bin/syslinux
	mkdir -p initrd_dir/bin
	cp syslinux-$(SYSLINUX_VERSION)/bios/mbr/mbr.bin initrd_dir/bin/mbr.bin

initrd_dir/bin/syslinux : syslinux_src
	mkdir -p initrd_dir/bin
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION) bios
	cp syslinux-$(SYSLINUX_VERSION)/bios/linux/syslinux initrd_dir/bin/syslinux

syslinux_src : syslinux-$(SYSLINUX_VERSION).tar.xz glibc_libs
	tar xJf syslinux-$(SYSLINUX_VERSION).tar.xz
	touch syslinux_src

initrd_dir/bin/isVMWare : glibc_libs
	mkdir -p initrd_dir/bin
	gcc -L glibc2 -o initrd_dir/bin/isVMWare isVMWare.c -lc -lc_nonshared glibc/elf/ld.so

initrd_dir/bin/isVPC : glibc_libs
	mkdir -p initrd_dir/bin
	gcc -L glibc -o initrd_dir/bin/isVPC isVPC.c -lc -lc_nonshared glibc/elf/ld.so

#### Busybox ####
initrd_dir/bin/busybox : busybox-$(BUSYBOX_VERSION).tar.bz2 glibc_libs patches/busybox.config patches/busybox.patch
	mkdir -p initrd_dir/bin
	tar xjf busybox-$(BUSYBOX_VERSION).tar.bz2 && \
	cd busybox-$(BUSYBOX_VERSION) && \
	cp ../patches/busybox.config .config && \
	patch -p0 < ../patches/busybox.patch && \
	$(MAKE) CC="gcc -L../glibc" busybox && \
	cp busybox ../initrd_dir/bin

initrd_dir/etc/folding/cgi-bin/index.cgi : initrd_dir/bin/busybox glibc_libs
	mkdir -p initrd_dir/etc/folding/cgi-bin
	cd busybox-$(BUSYBOX_VERSION)/networking && \
	gcc -o ../../initrd_dir/etc/folding/cgi-bin/index.cgi httpd_indexcgi.c -lc -lc_nonshared ../../glibc/elf/ld.so

### Additional libs ###
initrd_dir/lib64/libbz2.so.1: glibc_libs bzip2-$(BZIP_VERSION).tar.gz
	mkdir -p initrd_dir/lib
	mkdir -p initrd_dir/lib64
	tar xzf bzip2-$(BZIP_VERSION).tar.gz && \
	cd bzip2-$(BZIP_VERSION) && \
	gcc -shared -Wl,-soname -Wl,libbz2.so.1 -fpic -fPIC -Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64 -o ../initrd_dir/lib64/libbz2.so.1 -L ../glibc-64 blocksort.c huffman.c crctable.c randtable.c compress.c decompress.c bzlib.c -lc && \
	strip ../initrd_dir/lib64/libbz2.so.1 && \
	cd ../initrd_dir/lib && \
	ln -sf ../lib64/libbz2.so.1 libbz2.so.1

initrd_dir/lib64/libstdc++.so.6: initrd_dir/lib64/libgcc_s.so.1
	mkdir -p initrd_dir/lib64
	$(MAKE) -C gcc-$(GCC_VERSION) configure-target-libstdc++-v3
	$(MAKE) -C gcc-$(GCC_VERSION)/x86_64-unknown-linux-gnu/libstdc++-v3
	cp gcc-$(GCC_VERSION)/x86_64-unknown-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6 initrd_dir/lib64
	strip initrd_dir/lib64/libstdc++.so.6
	cd initrd_dir/lib && \
	ln -sf ../lib64/libstdc++.so.6 libstdc++.so.6

initrd_dir/lib64/libgcc_s.so.1: gcc_source glibc_libs
	mkdir -p initrd_dir/lib
	mkdir -p initrd_dir/lib64
	$(MAKE) -C gcc-$(GCC_VERSION) configure-target-libgcc && \
	$(MAKE) -C gcc-$(GCC_VERSION)/x86_64-unknown-linux-gnu/libgcc libgcc_s.so && \
	cp gcc-$(GCC_VERSION)/x86_64-unknown-linux-gnu/libgcc/libgcc_s.so.1 initrd_dir/lib64 && \
	strip initrd_dir/lib64/libgcc_s.so.1 && \
	cd initrd_dir/lib && \
	ln -sf ../lib64/libgcc_s.so.1 libgcc_s.so.1

gcc_source: gcc-$(GCC_VERSION).tar.bz2
	tar xjf gcc-$(GCC_VERSION).tar.bz2 && \
	cd gcc-$(GCC_VERSION) && \
	./configure --disable-bootstrap --enable-languages=c,c++ && \
	touch ../gcc_source

initrd_dir/lib64/libz.so.$(ZLIB_VERSION) : zlib_source
	mkdir -p initrd_dir/lib
	mkdir -p initrd_dir/lib64
	cd zlib-$(ZLIB_VERSION) && \
	$(MAKE) && \
	cp libz.so.$(ZLIB_VERSION) ../initrd_dir/lib64/libz.so.$(ZLIB_VERSION) && \
	cd ../initrd_dir/lib64 && \
	ln -sf libz.so.$(ZLIB_VERSION) libz.so.1 && \
	ln -sf libz.so.$(ZLIB_VERSION) libz.so && \
	cd ../lib && \
	ln -sf ../lib64/libz.so.$(ZLIB_VERSION) libz.so.$(ZLIB_VERSION) && \
	ln -sf libz.so.$(ZLIB_VERSION) libz.so.1 && \
	ln -sf libz.so.$(ZLIB_VERSION) libz.so

zlib_source : zlib-$(ZLIB_VERSION).tar.gz glibc_libs initrd_dir/lib64/libgcc_s.so.1
	tar xzf zlib-$(ZLIB_VERSION).tar.gz && \
	cd zlib-$(ZLIB_VERSION) && \
	./configure --prefix=/ && \
	touch ../zlib_source

initrd_dir/lib64/libssl.so.$(OPENSSL_VERSION) : openssl_source
	mkdir -p initrd_dir/lib
	mkdir -p initrd_dir/lib64
	cd openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL) && \
	LDFLAGS="-L$(CURDIR)/initrd_dir/lib64" CPPFLAGS="-I$(CURDIR)/zlib-$(ZLIB_VERSION)" $(MAKE) && \
	cp libssl.so.1.0.0 ../initrd_dir/lib64/libssl.so.$(OPENSSL_VERSION) && \
	cp libcrypto.so.1.0.0 ../initrd_dir/lib64/libcrypto.so.$(OPENSSL_VERSION) && \
	cd ../initrd_dir/lib64 && \
        ln -sf libssl.so.$(OPENSSL_VERSION) libssl.so.1.0.0 && \
	ln -sf libssl.so.$(OPENSSL_VERSION) libssl.so && \
	ln -sf libcrypto.so.$(OPENSSL_VERSION) libcrypto.so.1.0.0 && \
        ln -sf libcrypto.so.$(OPENSSL_VERSION) libcrypto.so && \
	cd ../lib && \
	ln -sf ../lib64/libssl.so.$(OPENSSL_VERSION) libssl.so.$(OPENSSL_VERSION) && \
        ln -sf libssl.so.$(OPENSSL_VERSION) libssl.so.1.0.0 && \
	ln -sf libssl.so.$(OPENSSL_VERSION) libssl.so && \
	ln -sf ../lib64/libcrypto.so.$(OPENSSL_VERSION) libcrypto.so.$(OPENSSL_VERSION) && \
        ln -sf libcrypto.so.$(OPENSSL_VERSION) libcrypto.so.1.0.0 && \
	ln -sf libcrypto.so.$(OPENSSL_VERSION) libcrypto.so

openssl_source : openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL).tar.gz glibc_libs initrd_dir/lib64/libz.so.$(ZLIB_VERSION) 
	tar xzf openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL).tar.gz && \
	cd openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL) && \
	LDFLAGS="-L$(CURDIR)/initrd_dir/lib64" CPPFLAGS="-I$(CURDIR)/zlib-$(ZLIB_VERSION)" ./config --prefix=/ shared zlib-dynamic no-rc5 no-idea && \
	touch ../openssl_source

initrd_dir/bin/wget : wget_source
	mkdir -p initrd_dir/bin
	cd wget-$(WGET_VERSION) && \
	LDFLAGS="-L$(CURDIR)/initrd_dir/lib64 -lssl" OPENSSL_LIBS="-L$(CURDIR)/initrd_dir/lib64" OPENSSL_CFLAGS="-I$(CURDIR)/openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL)/include" CPPFLAGS="-I$(CURDIR)/zlib-$(ZLIB_VERSION)" $(MAKE)
	cp wget-$(WGET_VERSION)/src/wget initrd_dir/bin/wget

wget_source : wget-$(WGET_VERSION).tar.xz glibc_libs initrd_dir/lib64/libz.so.$(ZLIB_VERSION) initrd_dir/lib64/libssl.so.$(OPENSSL_VERSION)
	tar xJf wget-$(WGET_VERSION).tar.xz && \
	cd wget-$(WGET_VERSION) && \
	LDFLAGS="-L$(CURDIR)/initrd_dir/lib64" CPPFLAGS="-I$(CURDIR)/zlib-$(ZLIB_VERSION) -I$(CURDIR)/openssl-$(OPENSSL_VERSION)$(OPENSSL_PATCH_LEVEL)/include" ./configure --prefix=/ --with-ssl=openssl --without-libuuid --disable-pcre
	touch wget_source

glibc_libs : glibc_src boot/kernel
	mkdir -p initrd_dir/lib
	mkdir -p initrd_dir/lib64
	mkdir -p glibc
	cd glibc && \
	../glibc-$(GLIBC_VERSION)/configure CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" --prefix=/usr --with-headers=$(CURDIR)/initrd_dir/include --enable-kernel=$(KERNEL_VERSION) --disable-profile && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" lib && \
        cd ../glibc-$(GLIBC_VERSION)/math && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc && \
	cd ../nptl && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc && \
	cd ../rt && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc && \
	cd ../nss && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc && \
	cd ../resolv && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc && \
	cd ../dlfcn && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc && \
	cd ../crypt && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc && \
	cd ../nis && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc
	cp glibc/libc.so initrd_dir/lib64/libc.so.6
	cp glibc/elf/ld-linux-x86-64.so.2 initrd_dir/lib64
	cp glibc/rt/librt.so.1 initrd_dir/lib64
	cp glibc/nptl/libpthread.so.0 initrd_dir/lib64
	cp glibc/math/libm.so.6 initrd_dir/lib64
	cp glibc/nss/libnss_files.so.2 initrd_dir/lib64
	cp glibc/resolv/libnss_dns.so.2 initrd_dir/lib64
	cp glibc/resolv/libresolv.so.2 initrd_dir/lib64
	cp glibc/dlfcn/libdl.so.2 initrd_dir/lib64
	cp glibc/crypt/libcrypt.so.1 initrd_dir/lib64
	cp glibc/nis/libnsl.so.1 initrd_dir/lib64
	cd initrd_dir/lib && \
	ln -sf ../lib64/libc.so.6 libc.so.6 && \
	ln -sf ../lib64/ld-linux-x86-64.so.2 ld-linux-x86-64.so.2 && \
	ln -sf ../lib64/librt.so.1 librt.so.1 && \
	ln -sf ../lib64/libpthread.so.0 libpthread.so.0 && \
	ln -sf ../lib64/libm.so.6 libm.so.6 && \
	ln -sf ../lib64/libnss_files.so.2 libnss_files.so.2 && \
	ln -sf ../lib64/libnss_dns.so.2 libnss_dns.so.2 && \
	ln -sf ../lib64/libresolv.so.2 libresolv.so.2 && \
	ln -sf ../lib64/libcrypt.so.1 libcrypt.so.1 && \
	ln -sf ../lib64/libdl.so.2 libdl.so.2 && \
	ln -sf ../lib64/libnsl.so.1 libnsl.so.1
	touch glibc_libs

glibc_src : glibc-$(GLIBC_VERSION).tar.xz
	tar xJf glibc-$(GLIBC_VERSION).tar.xz && \
	touch glibc_src

#### Kernel build targets ####

initrd_dir/etc/folding/cgi-bin/kernel : boot/kernel
	mkdir -p initrd_dir/etc/folding/cgi-bin
	cp boot/kernel initrd_dir/etc/folding/cgi-bin/kernel

kernel_firmware : boot/kernel
	git submodule update --init
	mkdir -p initrd_dir/lib/firmware
	if [ -d initrd_dir/lib/firmware/bnx2 ]; then rm -rf initrd_dir/lib/firmware/bnx2 ; fi
	cp -rf linux_firmware/bnx2/ initrd_dir/lib/firmware/bnx2/
	if [ -d initrd_dir/lib/firmware/bnx2x ]; then rm -rf initrd_dir/lib/firmware/bnx2x ; fi
	cp -rf linux_firmware/bnx2x/ initrd_dir/lib/firmware/bnx2x/
	if [ -d initrd_dir/lib/firmware/rtl_nic ]; then rm -rf initrd_dir/lib/firmware/rtl_nic ; fi
	cp -rf linux_firmware/rtl_nic/ initrd_dir/lib/firmware/rtl_nic/
	if [ -d initrd_dir/lib/firmware/e100 ]; then rm -rf initrd_dir/lib/firmware/e100 ; fi
	cp -rf linux_firmware/e100/ initrd_dir/lib/firmware/e100/
	if [ -d initrd_dir/lib/firmware/tigon ]; then rm -rf initrd_dir/lib/firmware/tigon ; fi
	cp -rf linux_firmware/tigon/ initrd_dir/lib/firmware/tigon/
	if [ -d initrd_dir/lib/firmware/3com ]; then rm -rf initrd_dir/lib/firmware/3com ; fi
	cp -rf linux_firmware/3com/ initrd_dir/lib/firmware/3com/
	touch kernel_firmware

boot/kernel : kernel_patch
	mkdir -p boot
	mkdir -p linux-$(KERNEL_VERSION)/usr
	$(MAKE) -C linux-$(KERNEL_VERSION)
	$(MAKE) -C linux-$(KERNEL_VERSION) headers_install ARCH=x86_64 INSTALL_HDR_PATH=$(CURDIR)/initrd_dir
	cp linux-$(KERNEL_VERSION)/arch/x86_64/boot/bzImage boot/kernel

kernel_patch : linux-$(KERNEL_VERSION).tar.xz patches/kernel.config
	tar xJf linux-$(KERNEL_VERSION).tar.xz
	cp patches/kernel.config linux-$(KERNEL_VERSION)/.config
	$(MAKE) -C linux-$(KERNEL_VERSION) olddefconfig
	touch kernel_patch
