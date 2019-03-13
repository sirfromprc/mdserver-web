#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")
sourcePath=${serverPath}/source
sysName=`uname`
install_tmp=${rootPath}/tmp/mw_install.pl

Install_php()
{
#------------------------ install start ------------------------------------#
echo "安装php-5.5.38 ..." > $install_tmp
mkdir -p $sourcePath/php
mkdir -p $serverPath/php

if [ ! -f $sourcePath/php/php-5.5.38.tar.xz ];then
	wget -O $sourcePath/php/php-5.5.38.tar.xz https://museum.php.net/php5/php-5.5.38.tar.xz
fi

if [ ! -d $sourcePath/php/php-5.5.38 ];then
	cd $sourcePath/php && tar -Jxf $sourcePath/php/php-5.5.38.tar.xz
fi

OPTIONS=''
if [ $sysName == 'Darwin' ]; then
	OPTIONS='--without-iconv'
else
	OPTIONS="--with-iconv=${serverPath}/lib/libiconv"
fi


cd $sourcePath/php/php-5.5.38 && ./configure \
--prefix=$serverPath/php/55 \
--exec-prefix=$serverPath/php/55 \
--with-config-file-path=$serverPath/php/55/etc \
--with-zlib-dir=$serverPath/lib/zlib \
--enable-mysqlnd \
--enable-zip \
--enable-intl \
--enable-mbstring \
--enable-sockets \
--enable-ftp \
--enable-wddx \
--enable-soap \
--enable-posix \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
$OPTIONS \
--enable-fpm \
&& make && make install && make clean

#------------------------ install end ------------------------------------#
}


Uninstall_php()
{
	$serverPath/php/init.d/php55 stop
	rm -rf $serverPath/php/55
	echo "卸载php-5.5.38 ..." > $install_tmp
}

action=${1}
if [ "${1}" == 'install' ];then
	Install_php
else
	Uninstall_php
fi