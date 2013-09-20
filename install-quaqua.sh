#!/bin/bash
VER=7.3.4
MVNVER=${VER}-SNAPSHOT
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
zip ../../libquaqua-${MVNVER}.zip libquaqua*
cp quaqua.jar ../../quaqua-${MVNVER}.jar 
cd ../..
sed -e s/VERSION/${MVNVER}/g < quaqua.pom.xml.master > quaqua.pom.xml
sed -e s/VERSION/${MVNVER}/g < libquaqua.pom.xml.master > libquaqua.pom.xml
echo "========= installation contents ========="
ls -l quaqua-${MVNVER}.jar libquaqua-${MVNVER}.zip
echo "============== zip contents ============="
unzip -l libquaqua-${MVNVER}.zip

echo "======== press return to install ========"
read TRASH
mvn install:install-file -Dfile=libquaqua-${MVNVER}.zip \
	-DgroupId=org.devzendo -DartifactId=LibQuaqua \
	-Dversion=${MVNVER} -Dpackaging=zip -DcreateChecksum=true \
	-DpomFile=libquaqua.pom.xml
mvn install:install-file -Dfile=quaqua-${MVNVER}.jar \
	-DgroupId=org.devzendo -DartifactId=Quaqua \
	-Dversion=${MVNVER} -Dpackaging=jar -DcreateChecksum=true \
	-DpomFile=quaqua.pom.xml

if [ "${MVNVER}" = "${VER}-SNAPSHOT" ]; then
    echo "====== press return to deploy snapshot ======"
    read TRASH
    ls -la
    mvn deploy:deploy-file \
         -Durl=https://oss.sonatype.org/content/repositories/snapshots/ \
         -DrepositoryId=sonatype-nexus-snapshots -DpomFile=libquaqua.pom.xml \
         -Dfile=libquaqua-${MVNVER}.zip
    mvn deploy:deploy-file \
         -Durl=https://oss.sonatype.org/content/repositories/snapshots/ \
         -DrepositoryId=sonatype-nexus-snapshots -DpomFile=quaqua.pom.xml \
         -Dfile=quaqua-${MVNVER}.jar
else
    echo "====== press return to sign/deploy non-snapshot ======"
    read TRASH
    mvn gpg:sign-and-deploy-file \
         -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
         -DrepositoryId=sonatype-nexus-staging -DpomFile=libquaqua.pom.xml
         -Dfile=libquaqua-${MVNVER}.zip
    mvn gpg:sign-and-deploy-file \
         -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
         -DrepositoryId=sonatype-nexus-staging -DpomFile=quaqua.pom.xml
         -Dfile=quaqua-${MVNVER}.jar
fi

cleanup


