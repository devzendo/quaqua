#!/bin/bash
VER=7.3.4
DIST=quaqua-${VER}.zip
UNZIPDIR=Quaqua
DISTDIR=${UNZIPDIR}/dist

cleanup() {
  rm -rf ${UNZIPDIR}
  rm quaqua-${VER}.jar libquaqua-${VER}.zip
  rm quaqua.pom.xml libquaqua.pom.xml
}

cleanup
echo "==== unzipping from ${DIST} ===="
unzip ${DIST} ${DISTDIR}/libquaqua.jnilib ${DISTDIR}/libquaqua64.jnilib ${DISTDIR}/quaqua.jar
cd ${DISTDIR}
zip ../../libquaqua-${VER}.zip libquaqua*
cp quaqua.jar ../../quaqua-${VER}.jar 
cd ../..
sed -e s/VERSION/${VER}/g < quaqua.pom.xml.master > quaqua.pom.xml
sed -e s/VERSION/${VER}/g < libquaqua.pom.xml.master > libquaqua.pom.xml
echo "========= installation contents ========="
ls -l quaqua-${VER}.jar libquaqua-${VER}.zip
echo "============== zip contents ============="
unzip -l libquaqua-${VER}.zip
echo "======== press return to install ========"
read TRASH
mvn install:install-file -Dfile=libquaqua-${VER}.zip \
	-DgroupId=org.devzendo -DartifactId=LibQuaqua \
	-Dversion=${VER} -Dpackaging=zip -DcreateChecksum=true \
	-DpomFile=quaqua.pom.xml
mvn install:install-file -Dfile=quaqua-${VER}.jar \
	-DgroupId=org.devzendo -DartifactId=Quaqua \
	-Dversion=${VER} -Dpackaging=jar -DcreateChecksum=true \
	-DpomFile=libquaqua.pom.xml
cleanup


