#!/bin/sh
VER=5.2.1
DIST=quaqua-${VER}.zip
DIR=Quaqua/dist
unzip ${DIST} ${DIR}/libquaqua.jnilib ${DIR}/libquaqua64.jnilib ${DIR}/quaqua.jar
cd ${DIR}
zip ../../libquaqua-${VER}.zip libquaqua*
cp quaqua.jar ../../quaqua-5.2.1.jar 
cd ../..
mvn install:install-file -Dfile=libquaqua-${VER}.zip \
	-DgroupId=ch.randelshofer -DartifactId=libquaqua \
	-Dversion=${VER} -Dpackaging=zip -DcreateChecksum=true \
	-DgeneratePom=true
mvn install:install-file -Dfile=quaqua-${VER}.jar \
	-DgroupId=ch.randelshofer -DartifactId=quaqua \
	-Dversion=${VER} -Dpackaging=jar -DcreateChecksum=true \
	-DgeneratePom=true
rm -rf ${DIR}
