WEBDIR = /var/www/reilly/folding
CGIDIR = /usr/lib/cgi-bin
LOOPDEV = $(shell sudo losetup -f)
MOUNT = /mnt

# Program Versions
KERNEL_VERSION = 3.13.2
GLIBC_VERSION = 2.17
BUSYBOX_VERSION = 1.22.1
SYSLINUX_VERSION = 3.86
BZIP_VERSION = 1.0.6
CDRKIT_VERSION = 1.1.7.1
GCC_VERSION = 4.8.2

all : folding_cd.iso diskless.zip usb.zip

.PHONY : prefetch distclean clean install_net install_web

distclean: clean
	-rm -rf linux-$(KERNEL_VERSION).tar.xz glibc-$(GLIBC_VERSION).tar.xz busybox-$(BUSYBOX_VERSION).tar.bz2 syslinux-$(SYSLINUX_VERSION).tar.bz2 bzip2-$(BZIP_VERSION).tar.gz cdrkit-$(CDRKIT_VERSION).tar.gz gcc-$(GCC_VERSION).tar.bz2

clean:
	-rm -rf linux-$(KERNEL_VERSION) glibc glibc_libs glibc-$(GLIBC_VERSION) glibc_src busybox-$(BUSYBOX_VERSION) syslinux-$(SYSLINUX_VERSION) syslinux_src bzip2-$(BZIP_VERSION) boot initrd_dir/lib initrd_dir/lib64 initrd_dir/bin/busybox initrd_dir/bin/encode initrd_dir/bin/isVMWare initrd_dir/bin/isVPC initrd_dir/bin/queueinfo initrd_dir/bin/mbr.bin initrd_dir/bin/syslinux initrd_dir/bin/isolinux.bin initrd_dir/etc/folding/cgi-bin/kernel initrd_dir/bin/genisoimage initrd_dir/etc/manifest initrd_dir/etc/folding/cgi-bin/fold.txt initrd_dir/etc/folding/cgi-bin/index.cgi diskless diskless.zip usb.zip kernel_patch folding_cd.iso folding.zip partition_table part_gen outfile disk folding cdrkit-$(CDRKIT_VERSION) gcc_source gcc-$(GCC_VERSION) initrd_dir/etc/folding/cgi-bin/isolinux.bin linux-firmware kernel_firmware initrd_dir/lib/firmware

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

prefetch : linux-$(KERNEL_VERSION).tar.xz glibc-$(GLIBC_VERSION).tar.xz busybox-$(BUSYBOX_VERSION).tar.bz2 syslinux-$(SYSLINUX_VERSION).tar.bz2 bzip2-$(BZIP_VERSION).tar.gz cdrkit-$(CDRKIT_VERSION).tar.gz gcc-$(GCC_VERSION).tar.bz2

linux-$(KERNEL_VERSION).tar.xz :
	wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-$(KERNEL_VERSION).tar.xz

glibc-$(GLIBC_VERSION).tar.xz :
	wget http://ftp.gnu.org/gnu/glibc/glibc-$(GLIBC_VERSION).tar.xz
	
busybox-$(BUSYBOX_VERSION).tar.bz2 :
	wget http://busybox.net/downloads/busybox-$(BUSYBOX_VERSION).tar.bz2

syslinux-$(SYSLINUX_VERSION).tar.bz2 :
	wget http://www.kernel.org/pub/linux/utils/boot/syslinux/3.xx/syslinux-$(SYSLINUX_VERSION).tar.bz2

bzip2-$(BZIP_VERSION).tar.gz :
	wget http://www.bzip.org/$(BZIP_VERSION)/bzip2-$(BZIP_VERSION).tar.gz

cdrkit-$(CDRKIT_VERSION).tar.gz :
	wget http://cdrkit.org/releases/cdrkit-$(CDRKIT_VERSION).tar.gz

gcc-$(GCC_VERSION).tar.bz2 :
	wget http://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)/gcc-$(GCC_VERSION).tar.bz2

### diskless.zip ###
diskless.zip : diskless/kernel diskless/initrd diskless/pxelinux.cfg/default diskless/pxelinux.0 diskless/fold.txt
	mkdir -p diskless
	cd diskless && \
	zip -r ../diskless.zip kernel initrd pxelinux.0 pxelinux.cfg/default fold.txt

diskless/kernel : boot/kernel
	mkdir -p boot
	cp boot/kernel diskless/kernel

diskless/initrd : boot/initrd
	mkdir -p boot
	cp boot/initrd diskless/initrd

diskless/pxelinux.cfg/default : boot/isolinux.cfg
	mkdir -p diskless/pxelinux.cfg && \
	cp boot/isolinux.cfg diskless/pxelinux.cfg/default

diskless/fold.txt : boot/fold.txt
	cp boot/fold.txt diskless/fold.txt

### usb.zip ###
usb.zip : diskless/kernel diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt
	mkdir -p diskless
	cd diskless && \
	zip -r ../usb.zip kernel initrd syslinux.cfg version.txt fold.txt

diskless/syslinux.cfg : boot/isolinux.cfg
	mkdir -p diskless
	cp boot/isolinux.cfg diskless/syslinux.cfg

diskless/version.txt : initrd_dir/init
	grep -m 1 VERSION= initrd_dir/init | sed s/VERSION=// > diskless/version.txt

### folding.zip ###
folding.zip: disk diskless/kernel diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt initrd_dir/bin/syslinux folding/folding.vmx
	mkdir folding
	mkdir -p $(MOUNT)
	sudo losetup -o 32256 $(LOOPDEV) disk && \
	mkdosfs -F 32 $(LOOPDEV) && \
	sudo mount $(LOOPDEV) $(MOUNT) && \
	sudo cp diskless/kernel diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt $(MOUNT) && \
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
folding_cd.iso : boot/kernel boot/initrd boot/isolinux.bin boot/isolinux.cfg boot/fold.txt
	cp boot/isolinux.bin boot/isolin.bin && \
	mkisofs -o folding_cd.iso -b isolin.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table boot && \
	rm boot/isolin.bin

boot/isolinux.cfg : patches/isolinux.cfg
	mkdir -p boot
	cp patches/isolinux.cfg boot

boot/fold.txt : patches/fold.txt
	mkdir -p boot
	cp patches/fold.txt boot

#### initrd ####
boot/initrd : initrd_dir/bin/isVMWare initrd_dir/bin/isVPC initrd_dir/bin/queueinfo initrd_dir/bin/busybox initrd_dir/bin/mbr.bin initrd_dir/bin/syslinux initrd_dir/etc/folding/cgi-bin/isolinux.bin initrd_dir/etc/folding/cgi-bin/kernel glibc_libs initrd_dir/init initrd_dir/bin/encode initrd_dir/bin/backup.sh initrd_dir/bin/check_hang.sh initrd_dir/bin/processor.awk initrd_dir/bin/average.awk initrd_dir/bin/bench.amber.awk initrd_dir/bin/bench.bonusgromacs.awk initrd_dir/bin/bench.gromacs33.awk initrd_dir/bin/bench.tinker.awk initrd_dir/bin/benchmark.sh initrd_dir/etc/folding/cgi-bin/index.cgi initrd_dir/etc/folding/cgi-bin/fold.txt initrd_dir/etc/folding/cgi-bin/reconf.cgi initrd_dir/etc/folding/cgi-bin/oneunit.cgi initrd_dir/lib64/libbz2.so.1 initrd_dir/lib64/libgcc_s.so.1 initrd_dir/lib64/libstdc++.so.6 initrd_dir/etc/folding/cgi-bin/fold.iso initrd_dir/bin/genisoimage kernel_firmware
	mkdir -p initrd_dir/tmp
	cd initrd_dir && \
	chmod 1777 tmp && \
	find . -name .svn -prune -o -print > etc/manifest && \
	bin/busybox cpio -o -H newc < etc/manifest | gzip -9 > ../boot/initrd

initrd_dir/bin/queueinfo : glibc_libs queueinfo.c
	mkdir -p initrd_dir/bin
	gcc -L glibc -o initrd_dir/bin/queueinfo queueinfo.c -lc -lc_nonshared glibc/elf/ld.so

initrd_dir/bin/encode : glibc_libs encode.c
	mkdir -p initrd_dir/bin
	gcc -L glibc -o initrd_dir/bin/encode encode.c -lc -lc_nonshared glibc/elf/ld.so

initrd_dir/etc/folding/cgi-bin/fold.txt : patches/fold.txt
	mkdir -p initrd_dir/etc/folding/cgi-bin
	cp patches/fold.txt initrd_dir/etc/folding/cgi-bin

initrd_dir/bin/genisoimage : glibc_libs cdrkit-$(CDRKIT_VERSION).tar.gz patches/genisoimage.patch
	mkdir -p initrd_dir/bin
	tar xzf cdrkit-$(CDRKIT_VERSION).tar.gz && \
	cd cdrkit-$(CDRKIT_VERSION) && \
	patch -p1 < ../patches/genisoimage.patch && \
	$(MAKE) build/Makefile && \
	cd build && \
	$(MAKE) genisoimage && \
	cp genisoimage/genisoimage ../../initrd_dir/bin/genisoimage

#### isolinux, pxelinux, syslinux ####
diskless/syslinux.exe : diskless/syslinux.com
	mkdir -p diskless
	$(MAKE) WINCC=i586-mingw32msvc-gcc WINAR=i586-mingw32msvc-ar WINRANLIB=i586-mingw32msvc-ranlib -C syslinux-$(SYSLINUX_VERSION)/win32 syslinux.exe && \
	cp syslinux-$(SYSLINUX_VERSION)/win32/syslinux.exe diskless/syslinux.exe

diskless/syslinux.com : initrd_dir/etc/folding/cgi-bin/isolinux.bin
	mkdir -p diskless
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/dos syslinux.com && \
	cp syslinux-$(SYSLINUX_VERSION)/dos/syslinux.com diskless/syslinux.com

initrd_dir/etc/folding/cgi-bin/isolinux.bin : boot/isolinux.bin
	mkdir -p initrd_dir/etc/folding/cgi-bin
	cp boot/isolinux.bin initrd_dir/etc/folding/cgi-bin/isolinux.bin

boot/isolinux.bin : diskless/pxelinux.0
	mkdir -p boot
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/core isolinux.bin && \
	cp syslinux-$(SYSLINUX_VERSION)/core/isolinux.bin boot/

diskless/pxelinux.0 : initrd_dir/bin/mbr.bin
	mkdir -p diskless
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/core pxelinux.0 && \
	cp syslinux-$(SYSLINUX_VERSION)/core/pxelinux.0 diskless/

initrd_dir/bin/mbr.bin : initrd_dir/bin/syslinux
	mkdir -p initrd_dir/bin
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/mbr mbr_bin.c && \
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/mbr mbr.bin && \
        cp syslinux-$(SYSLINUX_VERSION)/mbr/mbr.bin initrd_dir/bin/mbr.bin

initrd_dir/bin/syslinux : syslinux_src glibc_libs
	mkdir -p initrd_dir/bin
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/libinstaller ldlinux_bin.c && \
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/libinstaller bootsect_bin.c && \
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/linux syslinux.o && \
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/linux syslxmod.o && \
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/linux bootsect_bin.o && \
	$(MAKE) -C syslinux-$(SYSLINUX_VERSION)/linux ldlinux_bin.o && \
	gcc -s -L glibc -o initrd_dir/bin/syslinux syslinux-$(SYSLINUX_VERSION)/linux/syslinux.o syslinux-$(SYSLINUX_VERSION)/linux/syslxmod.o syslinux-$(SYSLINUX_VERSION)/linux/bootsect_bin.o syslinux-$(SYSLINUX_VERSION)/linux/ldlinux_bin.o -lc -lc_nonshared glibc/elf/ld.so

syslinux_src : syslinux-$(SYSLINUX_VERSION).tar.bz2
	tar xjf syslinux-$(SYSLINUX_VERSION).tar.bz2 && \
	cd syslinux-$(SYSLINUX_VERSION) && \
	cd $(CURDIR) && \
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
	patch -p1 < ../patches/busybox-1.22.1-ash.patch && \
	patch -p1 < ../patches/busybox-1.22.1-date.patch && \
	patch -p1 < ../patches/busybox-1.22.1-iplink.patch && \
	patch -p0 < ../patches/busybox.patch && \
	$(MAKE) CC="gcc -L../glibc" busybox && \
	cp busybox ../initrd_dir/bin

initrd_dir/etc/folding/cgi-bin/index.cgi : initrd_dir/bin/busybox glibc_libs
	mkdir -p initrd_dir/etc/folding/cgi-bin
	cd busybox-$(BUSYBOX_VERSION)/networking && \
	gcc -o ../../initrd_dir/etc/folding/cgi-bin/index.cgi -L ../../glibc httpd_indexcgi.c -lc -lc_nonshared

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
	$(MAKE) -C gcc-$(GCC_VERSION) configure-target-libstdc++-v3 && \
	$(MAKE) -C gcc-$(GCC_VERSION)/x86_64-unknown-linux-gnu/libstdc++-v3 && \
	cp gcc-$(GCC_VERSION)/x86_64-unknown-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6 initrd_dir/lib64 && \
	strip initrd_dir/lib64/libstdc++.so.6 && \
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
	./configure --disable-bootstrap && \
	touch ../gcc_source

glibc_libs : glibc_src boot/kernel
	mkdir -p initrd_dir/lib
	mkdir -p initrd_dir/lib64
	mkdir -p glibc && \
	cd glibc && \
	../glibc-$(GLIBC_VERSION)/configure CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" --prefix=/usr --with-headers=$(CURDIR)/linux-$(KERNEL_VERSION)/arch/x86/include/generated/uapi:$(CURDIR)/linux-$(KERNEL_VERSION)/arch/x86/include/uapi:$(CURDIR)/linux-$(KERNEL_VERSION)/include/generated/uapi:$(CURDIR)/linux-$(KERNEL_VERSION)/include/uapi:$(CURDIR)/linux-$(KERNEL_VERSION)/include:$(CURDIR)/linux-$(KERNEL_VERSION)/arch/x86/include --enable-kernel=$(KERNEL_VERSION) --disable-profile && \
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
	$(MAKE) CFLAGS="-O2 -fno-stack-protector -U_FORTIFY_SOURCE" -r srcdir=.. objdir=../../glibc && \
	cd $(CURDIR) && \
	cp glibc/libc.so initrd_dir/lib64/libc.so.6 && \
	cp glibc/elf/ld-linux-x86-64.so.2 initrd_dir/lib64 && \
	cp glibc/rt/librt.so.1 initrd_dir/lib64 && \
	cp glibc/nptl/libpthread.so.0 initrd_dir/lib64 && \
	cp glibc/math/libm.so.6 initrd_dir/lib64 && \
	cp glibc/nss/libnss_files.so.2 initrd_dir/lib64 && \
	cp glibc/resolv/libnss_dns.so.2 initrd_dir/lib64 && \
	cp glibc/resolv/libresolv.so.2 initrd_dir/lib64 && \
	cp glibc/dlfcn/libdl.so.2 initrd_dir/lib64 && \
	cp glibc/crypt/libcrypt.so.1 initrd_dir/lib64 && \
	cp glibc/nis/libnsl.so.1 initrd_dir/lib64 && \
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
	ln -sf ../lib64/libnsl.so.1 libnsl.so.1 && \
	cd $(CURDIR) && \
	touch glibc_libs

glibc_src : glibc-$(GLIBC_VERSION).tar.xz
	tar xJf glibc-$(GLIBC_VERSION).tar.xz && \
	touch glibc_src

#### Kernel build targets ####

initrd_dir/etc/folding/cgi-bin/kernel : boot/kernel
	mkdir -p initrd_dir/etc/folding/cgi-bin
	cp boot/kernel initrd_dir/etc/folding/cgi-bin/kernel

kernel_firmware :
	if [ -d linux-firmware ]; then rm -rf linux-firmware; fi
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
	mkdir -p initrd_dir/lib/firmware
	if [ -d initrd_dir/lib/firmware/bnx2 ]; then rm -rf initrd_dir/lib/firmware/bnx2 ; fi
	cp -rf linux-firmware/bnx2/ initrd_dir/lib/firmware/bnx2/
	if [ -d initrd_dir/lib/firmware/bnx2x ]; then rm -rf initrd_dir/lib/firmware/bnx2x ; fi
	cp -rf linux-firmware/bnx2x/ initrd_dir/lib/firmware/bnx2x/
	if [ -d initrd_dir/lib/firmware/rtl_nic ]; then rm -rf initrd_dir/lib/firmware/rtl_nic ; fi
	cp -rf linux-firmware/rtl_nic/ initrd_dir/lib/firmware/rtl_nic/
	if [ -d initrd_dir/lib/firmware/e100 ]; then rm -rf initrd_dir/lib/firmware/e100 ; fi
	cp -rf linux-firmware/e100/ initrd_dir/lib/firmware/e100/
	if [ -d initrd_dir/lib/firmware/tigon ]; then rm -rf initrd_dir/lib/firmware/tigon ; fi
	cp -rf linux-firmware/tigon/ initrd_dir/lib/firmware/tigon/
	if [ -d initrd_dir/lib/firmware/3com ]; then rm -rf initrd_dir/lib/firmware/3com ; fi
	cp -rf linux-firmware/3com/ initrd_dir/lib/firmware/3com/
	touch kernel_firmware

boot/kernel : kernel_patch
	mkdir -p boot
	$(MAKE) -C linux-$(KERNEL_VERSION) && \
	cp linux-$(KERNEL_VERSION)/arch/x86_64/boot/bzImage boot/kernel

kernel_patch : linux-$(KERNEL_VERSION).tar.xz patches/kernel.config
	tar xJf linux-$(KERNEL_VERSION).tar.xz && \
	cd linux-$(KERNEL_VERSION) && \
	cp ../patches/kernel.config .config && \
	make oldconfig && \
	cd .. && \
	touch kernel_patch
