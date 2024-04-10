# 1. base image를 만들기 위한 From 명령어, From <이미지>
# (Docker 파일에 가장 먼저 실행이 되어야 하는 명령어)
# eclipse-temurin:17은 JDK가 설치되어 있다. (Java Image는 deprecated 되었다.)
FROM eclipse-temurin:17 as build


# 2. 소스코드 가져오기
# 2-1. 작업 공간 마련하기 (마치 새 디렉토리를 생성한다고 보면 된다. 디렉토리가 없을 경우 생성 후 이동)
# WORKDIR: 현재 어디에서 작업을 하겠다.
# WORKDIR /app: 현재 app에서 작업을 하겠다. (cd /app과 같다.)
WORKDIR /app
# 2-2. 소스코드 복사해오기
# COPY . .: 바깥에 있는 .경로에 있는 파일들을 복사해서 이미지의 .경로로 이동시키겠다.
# dockerIgnore를 하면 특정 파일들은 가져오기 않게 설정할 수 있다.
COPY . .


# 3. 소스코드 빌드
# RUN: 명령어를 실행할 때, 사용하는 것이 RUN이다. (이미지를 설정하기 위한 명령이다.)
# 이미지 내부에서 새로운 명령어를 실행하고 그 이미지의 일부분으로서 새로운 레이어를 만들어 기존 레이어와 겹치게 한다.
# 단순 실행하기 위한 명령어가 아닌, 이미지에서 환경을 구성하기 위해 명령어를 실행할 땐 RUN을 실행
RUN <<EOF
./gradlew bootJar
mv build/libs/*.jar app.jar
EOF


# 여기부터 새로운 Stage가 시작된다.
FROM eclipse-temurin:17-jre

WORKDIR /app
# COPY를 하되, build 단계에서 만든 app.jar만 가져온다.
COPY --from=build /app/app.jar .

# 4. Jar 파일 실행
# CMD: 이미지를 가지고 만든 컨테이너가 실행할 명령이다.
CMD ["java", "-jar", "app.jar"]

# 4 + @. 컨테이너가 실행되었을 때 요청을 듣고있는 port를 나열해준다.
# because 컨테이너는 외부 환경과 격리되어 있기 때문에 어느 port에서 듣고 있는지 알 수 없기에 해준다.
EXPOSE 8080




# 정리.
# (사용하는 프레임워크에 따라서 이 기본적인 과정이 달라질 수 있다.)

# 간략 사용 정리 단계
# 1. 어떤 이미지에서 시작을 할 것인지 결정
# 2. 그 이미지를 서버라 생각하고 작업을 진행한 다음
# 3. 최종적으로 내 프로젝트를 실행하기 위한 명령을 나열