FROM ubuntu:bionic

RUN apt-get update && apt-get install -y curl

ENV ZOOVERS="3.4.13" \
    MINORVERS="1"

RUN curl https://www-us.apache.org/dist/zookeeper/zookeeper-${ZOOVERS}/zookeeper-${ZOOVERS}.tar.gz --output zookeeper-${ZOOVERS}.tar.gz

RUN tar -zxf zookeeper-${ZOOVERS}.tar.gz

RUN mkdir -p tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk && \
    mkdir -p tmzk-${ZOOVERS}-${MINORVERS}/DEBIAN && \
    mkdir -p tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/bin && \
    cp zookeeper-${ZOOVERS}/bin/*.sh tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/bin && \
    chmod +x tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/bin/*.sh && \
    mkdir -p tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/conf && \ 
    cp zookeeper-${ZOOVERS}/zookeeper-3.4.13.jar tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk && \
    mkdir tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/lib && \
    cp -R zookeeper-${ZOOVERS}/lib/*.jar tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/lib && \
    cp zookeeper-${ZOOVERS}/LICENSE.txt tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/LICENSE

COPY java.env tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/conf/
COPY log4j.properties tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/conf/
COPY zoo_sample.cfg tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/conf/
COPY tmzk.service tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk/tmzk.service

RUN chown -R root:root tmzk-${ZOOVERS}-${MINORVERS}/opt/tmzk

RUN echo "Package: tmzk \n\
Version: ${ZOOVERS}-${MINORVERS} \n\
Section: base \n\
Priority: optional \n\
Architecture: all \n\
Depends: openjdk-8-jre-headless (>= 8u181-b13-0ubuntu0.18.04.1) \n\
Maintainer: TrueMark <support@truemark.io> \n\
Description: TrueMark Apache Zookeeper \n\
 Apache Zookeeper installation for TrueMark service platform. " > tmzk-${ZOOVERS}-${MINORVERS}/DEBIAN/control

COPY postinst tmzk-${ZOOVERS}-${MINORVERS}/DEBIAN/
COPY preinst tmzk-${ZOOVERS}-${MINORVERS}/DEBIAN/
COPY postrm tmzk-${ZOOVERS}-${MINORVERS}/DEBIAN/
COPY prerm tmzk-${ZOOVERS}-${MINORVERS}/DEBIAN/

RUN dpkg-deb --build tmzk-${ZOOVERS}-${MINORVERS}

CMD cp tmzk*.deb /mnt
