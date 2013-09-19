#!/bin/sh
VER=7.3.4
DIST=quaqua-${VER}.zip
UNZIPDIR=Quaqua
DISTDIR=${UNZIPDIR}/dist
unzip ${DIST} ${DISTDIR}/libquaqua.jnilib ${DISTDIR}/libquaqua64.jnilib ${DISTDIR}/quaqua.jar
cd ${DISTDIR}
zip ../../libquaqua-${VER}.zip libquaqua*
cp quaqua.jar ../../quaqua-${VER}.jar 
cd ../..
echo press return to install:
ls -l quaqua-${VER}.jar libquaqua-${VER}.zip
unzip -l libquaqua-${VER}.zip
read TRASH
mvn install:install-file -Dfile=libquaqua-${VER}.zip \
	-DgroupId=ch.randelshofer -DartifactId=libquaqua \
	-Dversion=${VER} -Dpackaging=zip -DcreateChecksum=true \
	-DgeneratePom=true
mvn install:install-file -Dfile=quaqua-${VER}.jar \
	-DgroupId=ch.randelshofer -DartifactId=quaqua \
	-Dversion=${VER} -Dpackaging=jar -DcreateChecksum=true \
	-DgeneratePom=true
rm -rf ${UNZIPDIR}
rm quaqua-${VER}.jar libquaqua-${VER}.zip
