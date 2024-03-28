# 1. JDK 설치(되어 있는 이미지를 고르기)
FROM eclipse-temurin:17

# 2. 소스코드 가져오기
# 2-1. 작업 공간 마련하기 (없을 경우 생성 후 이동)
WORKDIR /app
# 2-2. 소스코드 복사해오기
COPY . .

# 3. 소스코드 빌드
# RUN: 이미지를 설정하기 위한 명령이다.
RUN <<EOF
./gradlew bootJar
mv build/libs/*.jar app.jar
EOF

# 4. Jar 파일 실행
# CMD: 이미지를 가지고 만든 컨테이너가 실행할 명령이다.
CMD ["java", "-jar", "app.jar"]
# 4 + @. 컨테이너가 실행되었을때 요청을 듣고있는 포트를 나열해준다.
EXPOSE 8080
