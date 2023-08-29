FROM ubuntu:latest

# 패키지 목록 업데이트
RUN apt-get update 

# Java 설치
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-11-jdk

# Maven 설치
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y maven

# wget 설치
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget

# 톰캣 다운로드 + 압축 풀기 + 디렉토리를 /tmp아래로 변경
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
RUN tar xvf apache-tomcat-9.0.75.tar.gz
RUN mv apache-tomcat-9.0.75 /tmp

# Git 설치
#RUN apt-get update && \
#    DEBIAN_FRONTEND=noninteractive apt-get install -y git && \
#    apt-get clean

# 작업 디렉토리 이동
WORKDIR /tmp/apache-tomcat-9.0.75/webapps

# 프로젝트 소스 다운로드
#RUN git clone https://github.com/helloalpaca/AdminHanaERP.git erp

# 호스트->컨테이너로 소스 COPY
COPY / /tmp/apache-tomcat-9.0.75/webapps/erp

# 리포지토리 디렉토리로 이동 + 빌드 명령어 + 파일 이동(webapps 바로 아래로 변경)
WORKDIR /tmp/apache-tomcat-9.0.75/webapps/erp
RUN mvn clean install
WORKDIR /tmp/apache-tomcat-9.0.75/webapps/erp/target
RUN mv addmin-hana-1.0-SNAPSHOT ../../addmin-hana

# DB 접속 정보 context.xml에 추가
RUN sed -i 's|<Context>|<Context>\n    <Resource\n        maxActive="100" maxIdle="20" maxWait="10000"\n        username="admin_hana" password="1234"\n        url="jdbc:oracle:thin:@localhost:1521:XE"\n        auth="Container"\n        type="javax.sql.DataSource"\n        driverClassName="oracle.jdbc.OracleDriver"\n        name="jdbc/oracle"\n        closeMethod="close" />|' /tmp/apache-tomcat-9.0.75/conf/context.xml

# 환경변수 설정 추가
WORKDIR /
RUN echo 'export JAVA_HOME=/lib/jvm/java-11-openjdk-amd64' >> /etc/profile
RUN echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile
RUN echo 'export CATALINA_HOME=/tmp/apache-tomcat-9.0.75' >> /etc/profile

# Tomcat 서비스 시작
WORKDIR /tmp/apache-tomcat-9.0.75/bin
CMD ["./catalina.sh", "run", ">", "catalina.log"]
