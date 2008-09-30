WEBDIR = /var/www/reilly/folding
CGIDIR = /usr/lib/cgi-bin
LOOPDEV = $(shell sudo losetup -f)
MOUNT = /mnt

all : folding_cd.iso diskless.zip usb.zip

.PHONY : clean install_net install_web
.NOTPARALLEL : glibc_32libs glibc64_libs

clean:
	-rm -rf linux-2.6.24.3 glibc-32 glibc_32libs glibc-64 glibc_64libs glibc-2.7 glibc_src samba_extract samba-3.0.27a busybox-1.9.1 syslinux-3.51 syslinux_src ntp-4.2.2p3 bzip2-1.0.5 boot/* initrd_dir/lib/* initrd_dir/lib64/* initrd_dir/bin/smbd initrd_dir/bin/nmbd initrd_dir/bin/busybox initrd_dir/bin/cpio-o initrd_dir/bin/encode initrd_dir/bin/ntpd initrd_dir/bin/isVMWare initrd_dir/bin/isVPC initrd_dir/bin/queueinfo initrd_dir/bin/mbr.bin initrd_dir/bin/syslinux initrd_dir/bin/isolinux.bin initrd_dir/etc/folding/cgi-bin/kernel32 initrd_dir/etc/folding/cgi-bin/kernel64 initrd_dir/bin/genisoimage initrd_dir/etc/manifest initrd_dir/etc/folding/cgi-bin/fold.txt initrd_dir/etc/folding/cgi-bin/index.cgi diskless/* diskless.zip usb.zip kernel_patch folding_cd.iso folding.zip partition_table part_gen outfile disk folding/folding.vmdk cdrkit-1.1.7.1 gcc_source gcc-4.3.1

### install_web ###
install_web: $(WEBDIR)/benchmark.html $(WEBDIR)/cd.html $(WEBDIR)/diskless.html $(WEBDIR)/diskless.zip $(WEBDIR)/index.html $(WEBDIR)/linux.html $(WEBDIR)/syslinux $(WEBDIR)/syslinux.com $(WEBDIR)/syslinux.exe $(WEBDIR)/usb.html $(WEBDIR)/usb.zip $(WEBDIR)/folding.zip $(WEBDIR)/vm.html $(CGIDIR)/fold.iso $(CGIDIR)/kernel32 $(CGIDIR)/kernel64 $(CGIDIR)/initrd $(CGIDIR)/isolinux.bin $(CGIDIR)/fold.txt

$(WEBDIR)/folding.zip : folding.zip
	cp folding.zip $(WEBDIR)

$(WEBDIR)/diskless.zip : diskless.zip
	cp diskless.zip $(WEBDIR)

$(WEBDIR)/index.html : web/index.html
	cp web/index.html $(WEBDIR)

$(WEBDIR)/syslinux : initrd_dir/bin/syslinux
	cp initrd_dir/bin/syslinux $(WEBDIR)

$(WEBDIR)/syslinux.com : diskless/syslinux.com
	cp diskless/syslinux.com $(WEBDIR)

$(WEBDIR)/syslinux.exe : diskless/syslinux.exe
	cp diskless/syslinux.exe $(WEBDIR)

$(WEBDIR)/usb.zip : usb.zip
	cp usb.zip $(WEBDIR)

$(CGIDIR)/fold.iso : initrd_dir/etc/folding/cgi-bin/fold.iso
	sudo cp initrd_dir/etc/folding/cgi-bin/fold.iso $(CGIDIR)

$(CGIDIR)/kernel32 : boot/kernel32
	sudo cp boot/kernel32 $(CGIDIR)

$(CGIDIR)/kernel64 : boot/kernel64
	sudo cp boot/kernel64 $(CGIDIR)

$(CGIDIR)/initrd : boot/initrd
	sudo cp boot/initrd $(CGIDIR)

$(CGIDIR)/isolinux.bin : boot/isolinux.bin
	sudo cp boot/isolinux.bin $(CGIDIR)

$(CGIDIR)/fold.txt : boot/fold.txt
	sudo cp boot/fold.txt $(CGIDIR)

$(WEBDIR)/benchmark.html : web/benchmark.html
	cp web/benchmark.html $(WEBDIR)

$(WEBDIR)/vm.html : NEWS web/vm.html
	cat web/vm.html > $(WEBDIR)/vm.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/vm.html && \
	echo "</body>" >> $(WEBDIR)/vm.html && \
	echo "</html>" >> $(WEBDIR)/vm.html

$(WEBDIR)/cd.html : NEWS web/cd.html
	cat web/cd.html > $(WEBDIR)/cd.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/cd.html && \
	echo "</body>" >> $(WEBDIR)/cd.html && \
	echo "</html>" >> $(WEBDIR)/cd.html

$(WEBDIR)/usb.html : NEWS web/usb.html
	cat web/usb.html > $(WEBDIR)/usb.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/usb.html && \
	echo "</body>" >> $(WEBDIR)/usb.html && \
	echo "</html>" >> $(WEBDIR)/usb.html

$(WEBDIR)/linux.html : NEWS web/linux.html
	cat web/linux.html > $(WEBDIR)/linux.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/linux.html && \
	echo "</body>" >> $(WEBDIR)/linux.html && \
	echo "</html>" >> $(WEBDIR)/linux.html

$(WEBDIR)/diskless.html : NEWS web/diskless.html
	cat web/diskless.html > $(WEBDIR)/diskless.html && \
	sed "a<BR>" NEWS >> $(WEBDIR)/diskless.html && \
	echo "</body>" >> $(WEBDIR)/diskless.html && \
	echo "</html>" >> $(WEBDIR)/diskless.html


### install_net ###
install_net: /var/lib/tftpboot/PXEClient/kernel32 /var/lib/tftpboot/PXEClient/kernel64 /var/lib/tftpboot/PXEClient/initrd /var/lib/tftpboot/PXEClient/pxelinux.cfg/default /var/lib/tftpboot/PXEClient/pxelinux.0 /var/lib/tftpboot/PXEClient/fold.txt

/var/lib/tftpboot/PXEClient/kernel32 : boot/kernel32
	cp boot/kernel32 /var/lib/tftpboot/PXEClient/kernel32

/var/lib/tftpboot/PXEClient/kernel64 : boot/kernel64
	cp boot/kernel64 /var/lib/tftpboot/PXEClient/kernel64

/var/lib/tftpboot/PXEClient/initrd : boot/initrd
	cp boot/initrd /var/lib/tftpboot/PXEClient/initrd

/var/lib/tftpboot/PXEClient/pxelinux.cfg/default : boot/isolinux.cfg
	cp boot/isolinux.cfg /var/lib/tftpboot/PXEClient/pxelinux.cfg/default

/var/lib/tftpboot/PXEClient/pxelinux.0 : diskless/pxelinux.0
	cp diskless/pxelinux.0 /var/lib/tftpboot/PXEClient/pxelinux.0

/var/lib/tftpboot/PXEClient/fold.txt : boot/fold.txt
	cp boot/fold.txt /var/lib/tftpboot/PXEClient/fold.txt


### diskless.zip ###
diskless.zip : diskless/kernel32 diskless/kernel64 diskless/initrd diskless/pxelinux.cfg/default diskless/pxelinux.0 diskless/fold.txt
	cd diskless && \
	zip -r ../diskless.zip kernel32 kernel64 initrd pxelinux.0 pxelinux.cfg/default fold.txt

diskless/kernel32 : boot/kernel32
	cp boot/kernel32 diskless/kernel32

diskless/kernel64 : boot/kernel64
	cp boot/kernel64 diskless/kernel64

diskless/initrd : boot/initrd
	cp boot/initrd diskless/initrd

diskless/pxelinux.cfg/default : boot/isolinux.cfg
	mkdir -p diskless/pxelinux.cfg && \
	cp boot/isolinux.cfg diskless/pxelinux.cfg/default

diskless/fold.txt : boot/fold.txt
	cp boot/fold.txt diskless/fold.txt

### usb.zip ###
usb.zip : diskless/kernel32 diskless/kernel64 diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt
	cd diskless && \
	zip -r ../usb.zip kernel32 kernel64 initrd syslinux.cfg version.txt fold.txt

diskless/syslinux.cfg : boot/isolinux.cfg
	cp boot/isolinux.cfg diskless/syslinux.cfg

diskless/version.txt : initrd_dir/init
	grep -m 1 VERSION= initrd_dir/init | sed s/VERSION=// > diskless/version.txt

### folding.zip ###
folding.zip: disk diskless/kernel32 diskless/kernel64 diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt initrd_dir/bin/syslinux folding/folding.vmx
	sudo losetup -o 32256 $(LOOPDEV) disk && \
	mkdosfs -F 32 $(LOOPDEV) && \
	sudo mount $(LOOPDEV) $(MOUNT) && \
	sudo cp diskless/kernel32 diskless/kernel64 diskless/initrd diskless/syslinux.cfg diskless/version.txt diskless/fold.txt $(MOUNT) && \
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
folding_cd.iso : boot/kernel32 boot/kernel64 boot/initrd boot/isolinux.bin boot/isolinux.cfg boot/fold.txt
	cp boot/isolinux.bin boot/isolin.bin && \
	mkisofs -o folding_cd.iso -b isolin.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table boot && \
	rm boot/isolin.bin

boot/isolinux.cfg : patches/isolinux.cfg
	cp patches/isolinux.cfg boot

boot/fold.txt : patches/fold.txt
	cp patches/fold.txt boot

#### initrd ####
boot/initrd : initrd_dir/bin/isVMWare initrd_dir/bin/isVPC initrd_dir/bin/queueinfo initrd_dir/bin/ntpd initrd_dir/bin/busybox initrd_dir/bin/mbr.bin initrd_dir/bin/syslinux initrd_dir/etc/folding/cgi-bin/isolinux.bin initrd_dir/etc/folding/cgi-bin/kernel32 initrd_dir/etc/folding/cgi-bin/kernel64 glibc_32libs glibc_64libs initrd_dir/init initrd_dir/bin/cpio-o initrd_dir/bin/encode initrd_dir/bin/backup.sh initrd_dir/bin/check_hang.sh initrd_dir/bin/smbd initrd_dir/bin/nmbd initrd_dir/bin/processor.awk initrd_dir/bin/average.awk initrd_dir/bin/bench.amber.awk initrd_dir/bin/bench.bonusgromacs.awk initrd_dir/bin/bench.gromacs33.awk initrd_dir/bin/bench.tinker.awk initrd_dir/bin/benchmark.sh initrd_dir/bin/genisoimage initrd_dir/etc/folding/cgi-bin/index.cgi initrd_dir/etc/folding/cgi-bin/fold.txt initrd_dir/etc/folding/cgi-bin/fold.iso initrd_dir/etc/folding/cgi-bin/reconf.cgi initrd_dir/lib64/libbz2.so.1 initrd_dir/lib64/libgcc_s.so.1 initrd_dir/lib64/libstdc++.so.6
	cd initrd_dir && \
	chmod 1777 tmp && \
	find . -name .svn -prune -o -print > etc/manifest && \
	bin/cpio-o < etc/manifest | gzip -9 > ../boot/initrd

initrd_dir/bin/queueinfo : glibc_32libs queueinfo.c
	gcc -m32 -L glibc-32 -o initrd_dir/bin/queueinfo queueinfo.c -lc -lc_nonshared glibc-32/elf/ld.so

initrd_dir/bin/cpio-o : glibc_32libs cpio-o.c
	gcc -m32 -L glibc-32 -o initrd_dir/bin/cpio-o cpio-o.c -lc -lc_nonshared glibc-32/elf/ld.so

initrd_dir/bin/encode : glibc_32libs encode.c
	gcc -m32 -L glibc-32 -o initrd_dir/bin/encode encode.c -lc -lc_nonshared glibc-32/elf/ld.so

initrd_dir/etc/folding/cgi-bin/fold.txt : patches/fold.txt
	cp patches/fold.txt initrd_dir/etc/folding/cgi-bin

initrd_dir/bin/genisoimage : glibc_32libs cdrkit-1.1.7.1.tar.gz patches/genisoimage.patch
	tar xzf cdrkit-1.1.7.1.tar.gz && \
	cd cdrkit-1.1.7.1 && \
	patch -p1 < ../patches/genisoimage.patch && \
	$(MAKE) CC="gcc -m32" build/Makefile && \
	cd build && \
	$(MAKE) CC="gcc -m32" genisoimage && \
	cp genisoimage/genisoimage ../../initrd_dir/bin/genisoimage


#### isolinux, pxelinux, syslinux ####
initrd_dir/etc/folding/cgi-bin/isolinux.bin : boot/isolinux.bin
	cp boot/isolinux.bin initrd_dir/etc/folding/cgi-bin/isolinux.bin

boot/isolinux.bin : syslinux_src
	cd syslinux-3.51 && \
	$(MAKE) isolinux.bin && \
	cp isolinux.bin ../boot

diskless/pxelinux.0 : syslinux_src
	cd syslinux-3.51 && \
	$(MAKE) pxelinux.0 && \
	cp pxelinux.0 ../diskless

initrd_dir/bin/mbr.bin : syslinux_src
	cd syslinux-3.51 && \
	$(MAKE) mbr/mbr.bin && \
        cp mbr/mbr.bin ../initrd_dir/bin/mbr.bin

diskless/syslinux.exe : syslinux-3.51/mbr_bin.c syslinux-3.51/bootsect_bin.c syslinux-3.51/ldlinux_bin.c
	$(MAKE) WINCC=i586-mingw32msvc-gcc WINAR=i586-mingw32msvc-ar WINRANLIB=i586-mingw32msvc-ranlib -C syslinux-3.51/win32 syslinux.exe && \
	cp syslinux-3.51/win32/syslinux.exe diskless/syslinux.exe

diskless/syslinux.com : syslinux-3.51/mbr_bin.c syslinux-3.51/bootsect_bin.c syslinux-3.51/ldlinux_bin.c
	$(MAKE) CC="gcc -m32" -C syslinux-3.51/dos syslinux.com && \
	cp syslinux-3.51/dos/syslinux.com diskless/syslinux.com

initrd_dir/bin/syslinux : syslinux-3.51/unix/syslinux.o syslinux-3.51/unix/syslxmod.o syslinux-3.51/unix/bootsect_bin.o syslinux-3.51/unix/ldlinux_bin.o glibc_32libs
	gcc -m32 -s -L glibc-32 -o initrd_dir/bin/syslinux syslinux-3.51/unix/syslinux.o syslinux-3.51/unix/syslxmod.o syslinux-3.51/unix/bootsect_bin.o syslinux-3.51/unix/ldlinux_bin.o -lc -lc_nonshared glibc-32/elf/ld.so

syslinux-3.51/unix/syslinux.o : syslinux_src
	$(MAKE) CC="gcc -m32" -C syslinux-3.51/unix syslinux.o

syslinux-3.51/unix/syslxmod.o : syslinux_src
	$(MAKE) CC="gcc -m32" -C syslinux-3.51/unix syslxmod.o

syslinux-3.51/unix/bootsect_bin.o : syslinux-3.51/bootsect_bin.c
	$(MAKE) CC="gcc -m32" -C syslinux-3.51/unix bootsect_bin.o

syslinux-3.51/unix/ldlinux_bin.o : syslinux-3.51/ldlinux_bin.c
	$(MAKE) CC="gcc -m32" -C syslinux-3.51/unix ldlinux_bin.o

syslinux-3.51/bootsect_bin.c : syslinux_src
	$(MAKE) CC="gcc -m32" -C syslinux-3.51 bootsect_bin.c

syslinux-3.51/ldlinux_bin.c : syslinux_src
	$(MAKE) CC="gcc -m32" -C syslinux-3.51 ldlinux_bin.c

syslinux-3.51/mbr_bin.c : syslinux_src
	$(MAKE) CC="gcc -m32" -C syslinux-3.51 mbr_bin.c

syslinux_src :
	tar xjf syslinux-3.51.tar.bz2 && \
	cd syslinux-3.51 && \
	patch -p1 < ../patches/syslinux-3.51-64bit.patch && \
	cd $(CURDIR) && \
	touch syslinux_src

#### Samba ####
initrd_dir/bin/smbd : samba_extract glibc_32libs
	cd samba-3.0.27a/source && \
	$(MAKE) CC="gcc -m32 -L../../glibc-32" LIBS="../../glibc-32/resolv/libresolv.so ../../glibc-32/nis/libnsl.so -lc -lc_nonshared ../../glibc-32/elf/ld.so" bin/smbd && \
	cp bin/smbd ../../initrd_dir/bin/smbd

initrd_dir/bin/nmbd : samba_extract glibc_32libs
	cd samba-3.0.27a/source && \
	$(MAKE) CC="gcc -m32 -L../../glibc-32" LIBS="../../glibc-32/resolv/libresolv.so ../../glibc-32/nis/libnsl.so -lc -lc_nonshared ../../glibc-32/elf/ld.so" bin/nmbd && \
	cp bin/nmbd ../../initrd_dir/bin/nmbd 

samba_extract :
	tar xzf samba-3.0.27a.tar.gz samba-3.0.27a/source && \
	cd samba-3.0.27a/source && \
	./configure CC="gcc -m32 -L../../glibc-32" LIBS="-lc -lc_nonshared ../../glibc-32/elf/ld.so" --with-lockdir=/tmp --with-piddir=/tmp --with-configdir=/etc --with-privatedir=/tmp --with-logfilebase=/tmp && \
	$(MAKE) CC="gcc -m32 -L../../glibc-32" LIBS="-lc -lc_nonshared ../../glibc-32/elf/ld.so" include/proto.h
	cd $(CURDIR) && \
	touch samba_extract

#### VM Detectors ####
initrd_dir/bin/isVMWare : glibc_32libs
	gcc -m32 -L glibc-32 -o initrd_dir/bin/isVMWare isVMWare.c -lc -lc_nonshared glibc-32/elf/ld.so

initrd_dir/bin/isVPC : glibc_32libs
	gcc -m32 -L glibc-32 -o initrd_dir/bin/isVPC isVPC.c -lc -lc_nonshared glibc-32/elf/ld.so

#### ntpd ####
initrd_dir/bin/ntpd : glibc_32libs
	tar xzf ntp-4.2.2p3.tar.gz && \
	cd ntp-4.2.2p3 && \
	./configure CC="gcc -m32" --prefix=/ --disable-clockctl --disable-linuxcaps --disable-debugging --disable-all-clocks --disable-ipv6 --without-binsub --without-crypto --without-sntp && \
	cd ntpd && \
	$(MAKE) CC="gcc -m32 -L../../glibc-32" ntpd_LDADD="version.o libntpd.a ../libntp/libntp.a ../../glibc-32/math/libm.so ../../glibc-32/libc.so ../../glibc-32/libc_nonshared.a ../../glibc-32/elf/ld.so" ntpd && \
	strip --strip-debug ntpd && \
	cp ntpd ../../initrd_dir/bin

#### Busybox ####
initrd_dir/bin/busybox : glibc_32libs patches/busybox.config
	tar xjf busybox-1.9.1.tar.bz2 && \
	cd busybox-1.9.1 && \
	cp ../patches/busybox.config .config && \
	patch < ../patches/busybox.patch && \
	$(MAKE) CC="gcc -m32 -L../glibc-32" busybox && \
	cp busybox ../initrd_dir/bin

initrd_dir/etc/folding/cgi-bin/index.cgi : initrd_dir/bin/busybox glibc_32libs
	cd busybox-1.9.1/networking && \
	gcc -m32 -o ../../initrd_dir/etc/folding/cgi-bin/index.cgi -L ../../glibc-32  httpd_indexcgi.c -lc -lc_nonshared

### Additional libs ###
initrd_dir/lib64/libbz2.so.1: glibc_64libs bzip2-1.0.5.tar.gz
	tar xzf bzip2-1.0.5.tar.gz && \
	cd bzip2-1.0.5 && \
	gcc -shared -Wl,-soname -Wl,libbz2.so.1 -fpic -fPIC -Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64 -o ../initrd_dir/lib64/libbz2.so.1 -L ../glibc-64 blocksort.c huffman.c crctable.c randtable.c compress.c decompress.c bzlib.c -lc && \
	strip ../initrd_dir/lib64/libbz2.so.1

initrd_dir/lib64/libstdc++.so.6: initrd_dir/lib64/libgcc_s.so.1
	$(MAKE) -C gcc-4.3.1 configure-target-libstdc++-v3 && \
	$(MAKE) -C gcc-4.3.1/x86_64-unknown-linux-gnu/libstdc++-v3 && \
	cp gcc-4.3.1/x86_64-unknown-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6 initrd_dir/lib64 && \
	strip initrd_dir/lib64/libstdc++.so.6

initrd_dir/lib64/libgcc_s.so.1: gcc_source glibc_64libs
	$(MAKE) -C gcc-4.3.1 configure-target-libgcc && \
	$(MAKE) -C gcc-4.3.1/x86_64-unknown-linux-gnu/libgcc libgcc_s.so && \
	cp gcc-4.3.1/x86_64-unknown-linux-gnu/libgcc/libgcc_s.so.1 initrd_dir/lib64 && \
	strip initrd_dir/lib64/libgcc_s.so.1

gcc_source: gcc-core-4.3.1.tar.bz2 gcc-g++-4.3.1.tar.bz2
	tar xjf gcc-core-4.3.1.tar.bz2 && \
	tar xjf gcc-g++-4.3.1.tar.bz2 && \
	cd gcc-4.3.1 && \
	./configure --disable-bootstrap && \
	touch ../gcc_source

#### Glibc build targets ####
glibc_32libs : glibc_src boot/kernel32
	ln -s asm-x86 linux-2.6.24.3/include/asm && \
	mkdir -p glibc-32 && \
	cd glibc-32 && \
	../glibc-2.7/configure  CC="gcc -m32" CFLAGS="-march=i586 -O2 -fno-stack-protector" --prefix=/usr --with-headers=$(CURDIR)/linux-2.6.24.3/include:$(CURDIR)/linux-2.6.24.3/kernel_32/include --enable-kernel=2.6.24 --disable-profile --host=i586-linux && \
	$(MAKE) CC="gcc -m32" CFLAGS="-march=i586 -O2 -fno-stack-protector" lib && \
	cd ../glibc-2.7/math && \
	$(MAKE) CC="gcc -m32" CFLAGS="-march=i586 -O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-32 && \
	cd ../nptl && \
	$(MAKE) CC="gcc -m32" CFLAGS="-march=i586 -O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-32 && \
	cd ../nss && \
	$(MAKE) CC="gcc -m32" CFLAGS="-march=i586 -O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-32 && \
	cd ../resolv && \
	$(MAKE) CC="gcc -m32" CFLAGS="-march=i586 -O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-32 && \
        cd ../crypt && \
	$(MAKE) CC="gcc -m32" CFLAGS="-march=i586 -O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-32 && \
	cd ../nis && \
	$(MAKE) CC="gcc -m32" CFLAGS="-march=i586 -O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-32 && \
	cd $(CURDIR) && \
	rm linux-2.6.24.3/include/asm && \
	cp glibc-32/libc.so initrd_dir/lib/libc.so.6 && \
	cp glibc-32/elf/ld-linux.so.2 initrd_dir/lib && \
	cp glibc-32/nptl/libpthread.so.0 initrd_dir/lib && \
	cp glibc-32/math/libm.so.6 initrd_dir/lib && \
	cp glibc-32/nss/libnss_files.so.2 initrd_dir/lib && \
	cp glibc-32/resolv/libnss_dns.so.2 initrd_dir/lib && \
	cp glibc-32/resolv/libresolv.so.2 initrd_dir/lib && \
	cp glibc-32/crypt/libcrypt.so.1 initrd_dir/lib && \
	cp glibc-32/nis/libnsl.so.1 initrd_dir/lib && \
	touch glibc_32libs

glibc_64libs : glibc_src boot/kernel64
	ln -s asm-x86 linux-2.6.24.3/include/asm && \
	mkdir -p glibc-64 && \
	cd glibc-64 && \
	../glibc-2.7/configure CFLAGS="-O2 -fno-stack-protector" --prefix=/usr --with-headers=$(CURDIR)/linux-2.6.24.3/include:$(CURDIR)/linux-2.6.24.3/kernel_64/include --enable-kernel=2.6.24 --disable-profile && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector" lib && \
        cd ../glibc-2.7/math && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-64 && \
	cd ../nptl && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-64 && \
	cd ../rt && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-64 && \
	cd ../nss && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-64 && \
	cd ../resolv && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-64 && \
	cd ../dlfcn && \
	$(MAKE) CFLAGS="-O2 -fno-stack-protector" -r srcdir=.. objdir=../../glibc-64 && \
	cd $(CURDIR) && \
	rm linux-2.6.24.3/include/asm && \
	cp glibc-64/libc.so initrd_dir/lib64/libc.so.6 && \
	cp glibc-64/elf/ld-linux-x86-64.so.2 initrd_dir/lib64 && \
	cp glibc-64/rt/librt.so.1 initrd_dir/lib64 && \
	cp glibc-64/nptl/libpthread.so.0 initrd_dir/lib64 && \
	cp glibc-64/math/libm.so.6 initrd_dir/lib64 && \
	cp glibc-64/nss/libnss_files.so.2 initrd_dir/lib64 && \
	cp glibc-64/resolv/libnss_dns.so.2 initrd_dir/lib64 && \
	cp glibc-64/resolv/libresolv.so.2 initrd_dir/lib64 && \
	cp glibc-64/dlfcn/libdl.so.2 initrd_dir/lib64 && \
	touch glibc_64libs

glibc_src : glibc-2.7.tar.bz2
	tar xjf glibc-2.7.tar.bz2 && \
	cd glibc-2.7 && \
	patch -p0  < ../patches/glibc.patch && \
	touch ../glibc_src

#### Kernel build targets ####
initrd_dir/etc/folding/cgi-bin/kernel32 : boot/kernel32
	cp boot/kernel32 initrd_dir/etc/folding/cgi-bin/kernel32

initrd_dir/etc/folding/cgi-bin/kernel64 : boot/kernel64
	cp boot/kernel64 initrd_dir/etc/folding/cgi-bin/kernel64

boot/kernel32 : kernel_patch
	$(MAKE) -C linux-2.6.24.3 O=kernel_32 ARCH="i386" CC="gcc -m32" LD="ld -m elf_i386" && \
	cp linux-2.6.24.3/kernel_32/arch/i386/boot/bzImage boot/kernel32

boot/kernel64 : kernel_patch
	$(MAKE) -C linux-2.6.24.3 O=kernel_64 && \
	cp linux-2.6.24.3/kernel_64/arch/x86_64/boot/bzImage boot/kernel64

kernel_patch : linux-2.6.24.3.tar.bz2 patches/kernel_ioctl.patch patches/kernel32.config patches/kernel64.config
	tar xjf linux-2.6.24.3.tar.bz2 && \
	cd linux-2.6.24.3 && \
	patch -p1 < ../patches/kernel_ioctl.patch && \
	mkdir -p kernel_64 && \
	cp ../patches/kernel64.config kernel_64/.config && \
	mkdir -p kernel_32 && \
	cp ../patches/kernel32.config kernel_32/.config && \
	cd .. && \
	touch kernel_patch
