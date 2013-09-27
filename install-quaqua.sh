#!/bin/bash
VER=7.3.4
MVNVER=${VER}
#MVNVER=${VER}-SNAPSHOT
DIST=quaqua-${VER}.zip
UNZIPDIR=Quaqua
DISTDIR=${UNZIPDIR}/dist

cleanup() {
  rm -rf ${UNZIPDIR} 2> /dev/null
  rm quaqua-${MVNVER}.jar libquaqua-${MVNVER}.zip quaqua-${MVNVER}-sources.jar quaqua-${MVNVER}-javadoc.jar 2> /dev/null
  rm libquaqua-${MVNVER}-sources.jar libquaqua-${MVNVER}-javadoc.jar 2> /dev/null
  rm quaqua.pom.xml libquaqua.pom.xml 2> /dev/null
  rm *.asc 2> /dev/null
}

cleanup
echo "==== unzipping from ${DIST} ===="
unzip -q ${DIST} ${DISTDIR}/libquaqua.jnilib ${DISTDIR}/libquaqua64.jnilib ${DISTDIR}/quaqua.jar ${UNZIPDIR}/src/* ${DISTDIR}/javadoc/*

echo "===== making release files ====="
cd ${DISTDIR}
# Quaqua/dist
zip ../../libquaqua-${MVNVER}.zip libquaqua*

cp quaqua.jar ../../quaqua-${MVNVER}.jar 

cd javadoc
jar cf ../../../quaqua-${MVNVER}-javadoc.jar .
cd ..

cd ../src
mv native ..
# Quaqua/src
jar cf ../../quaqua-${MVNVER}-sources.jar .
cd ../native
# Quaqua/native
jar cf ../../libquaqua-${MVNVER}-sources.jar .
doxygen ../../doxygen.conf > /dev/null 2>&1
cd html
# Quaqua/native/html
jar cf ../../../libquaqua-${MVNVER}-javadoc.jar .

cd ..
# Quaqua/native

cd ../..
# root

sed -e s/VERSION/${MVNVER}/g < quaqua.pom.xml.master > quaqua.pom.xml
sed -e s/VERSION/${MVNVER}/g < libquaqua.pom.xml.master > libquaqua.pom.xml
echo "========= installation contents ========="
ls -l quaqua-${MVNVER}.jar libquaqua-${MVNVER}.zip quaqua-${MVNVER}-sources.jar quaqua-${MVNVER}-javadoc.jar \
	libquaqua-${MVNVER}-sources.jar libquaqua-${MVNVER}-javadoc.jar

echo "========= press return to view =========="
read TRASH
echo "============== zip contents ============="
unzip -l libquaqua-${MVNVER}.zip
echo "========== source jar contents =========="
jar tf quaqua-${MVNVER}-sources.jar
echo "======= native source jar contents ======"
jar tf libquaqua-${MVNVER}-sources.jar
echo "========= javadoc jar contents =========="
jar tf quaqua-${MVNVER}-javadoc.jar
echo "====== native javadoc jar contents ======"
jar tf libquaqua-${MVNVER}-javadoc.jar

echo "======== press return to install ========"
read TRASH
mvn install:install-file -Dfile=libquaqua-${MVNVER}.zip \
	-DgroupId=org.devzendo -DartifactId=LibQuaqua \
	-Dversion=${MVNVER} -Dpackaging=zip -DcreateChecksum=true \
	-DpomFile=libquaqua.pom.xml
mvn install:install-file -Dfile=libquaqua-${MVNVER}-sources.jar \
	-DgroupId=org.devzendo -DartifactId=LibQuaqua \
	-Dversion=${MVNVER} -Dpackaging=jar -DcreateChecksum=true \
	-Dclassifier=sources -DpomFile=libquaqua.pom.xml
mvn install:install-file -Dfile=libquaqua-${MVNVER}-sources.jar \
	-DgroupId=org.devzendo -DartifactId=LibQuaqua \
	-Dversion=${MVNVER} -Dpackaging=jar -DcreateChecksum=true \
	-Dclassifier=javadoc -DpomFile=libquaqua.pom.xml
mvn install:install-file -Dfile=quaqua-${MVNVER}.jar \
	-DgroupId=org.devzendo -DartifactId=Quaqua \
	-Dversion=${MVNVER} -Dpackaging=jar -DcreateChecksum=true \
	-DpomFile=quaqua.pom.xml
mvn install:install-file -Dfile=quaqua-${MVNVER}-sources.jar \
	-DgroupId=org.devzendo -DartifactId=Quaqua \
	-Dversion=${MVNVER} -Dpackaging=jar -DcreateChecksum=true \
        -Dclassifier=sources -DpomFile=quaqua.pom.xml
mvn install:install-file -Dfile=quaqua-${MVNVER}-javadoc.jar \
	-DgroupId=org.devzendo -DartifactId=Quaqua \
	-Dversion=${MVNVER} -Dpackaging=jar -DcreateChecksum=true \
        -Dclassifier=javadoc -DpomFile=quaqua.pom.xml


if [ "${MVNVER}" = "${VER}-SNAPSHOT" ]; then
    echo "====== press return to deploy snapshot ======"
    read TRASH
    mvn deploy:deploy-file \
         -Durl=https://oss.sonatype.org/content/repositories/snapshots/ \
         -DrepositoryId=sonatype-nexus-snapshots -DpomFile=libquaqua.pom.xml \
         -Dfile=libquaqua-${MVNVER}.zip -Dclassifiers=sources,javadoc \
         -Dfiles=libquaqua-${MVNVER}-sources.jar,libquaqua-${MVNVER}-javadoc.jar \
         -Dtypes=jar,jar
    mvn deploy:deploy-file \
         -Durl=https://oss.sonatype.org/content/repositories/snapshots/ \
         -DrepositoryId=sonatype-nexus-snapshots -DpomFile=quaqua.pom.xml \
         -Dfile=quaqua-${MVNVER}.jar -Dclassifiers=sources,javadoc \
         -Dfiles=quaqua-${MVNVER}-sources.jar,quaqua-${MVNVER}-javadoc.jar \
         -Dtypes=jar,jar
else
    echo "====== press return to sign/deploy non-snapshot ======"
    read TRASH
    KEYOK=2
    while [ $KEYOK != 0 ]
    do
	    echo "==== enter gpg passphrase ======"
	    stty -echo
	    read PP
	    stty echo
	    echo "1234" | gpg --no-use-agent -o /dev/null --passphrase "$PP" -as -
	    KEYOK=$?
    done

    mvn gpg:sign-and-deploy-file \
         -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
         -DrepositoryId=sonatype-nexus-staging -DpomFile=libquaqua.pom.xml \
         -Dfile=libquaqua-${MVNVER}.zip -Darguments=-Dgpg.passphrase="$PP" \
         -Dclassifiers=sources,javadoc \
         -Dfiles=libquaqua-${MVNVER}-sources.jar,libquaqua-${MVNVER}-javadoc.jar \
         -Dtypes=jar,jar
    mvn gpg:sign-and-deploy-file \
         -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
         -DrepositoryId=sonatype-nexus-staging -DpomFile=quaqua.pom.xml \
         -Dfile=quaqua-${MVNVER}.jar -Darguments=-Dgpg.passphrase="$PP" \
         -Dclassifiers=sources,javadoc \
         -Dfiles=quaqua-${MVNVER}-sources.jar,quaqua-${MVNVER}-javadoc.jar \
         -Dtypes=jar,jar
fi

cleanup


