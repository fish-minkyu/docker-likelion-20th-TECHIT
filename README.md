# Docker & Docker Image workflow <- 복습해서 재정리 필요

### 스팩

- Spring Boot 3.2.3
- Spring Data JPA
- H2database
- Thymeleaf
- Lombok
- MySQL

## GitHub

[강사님 GitHub](https://github.com/edujeeho0/todo-boot)

---

## Docker

- 2024.03.27 ~ 04.01 `20주차`

- 03.27 - Docker 이론 설명, [Ubuntu] Docker Engine 설치 및 도커 환경에서 RabbitMQ 실행 
- 03.28 - ubuntu 서버에서 Docker 실행, Multi-stage Build
- 04.01 - Multi Container Application: MySQL 컨테이너 실행, Network 구성, Docker compose 

### Key Point

<details>
<summary><strong>Docker 명령어</strong></summary>
</details>

<details>
<summary><strong>Multi-stage Build</strong></summary>
</details>

<details>
<summary><strong>Docker 명령어 정리</strong></summary>
</details>

<details>
<summary><strong>Docker을 이용한 배포 (4월 2일까지 진행)</strong></summary>

- `docker-image.yml`

```shell
# Delivery 까지만 진행한다.
name: Docker Image Delivery

on:
  workflow_dispatch:

jobs:
  deliver:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Source
        uses: actions/checkout@v4
      # 이미지 태그 설정
      - name: Set Image Tag
        id: image-tag
        run: echo "TAG=$(date +%s)-ci" >> "$GITHUB_OUTPUT"
      # Docker Build 진행
      - name: Build the Docker image
        env:
          TAG: ${{ steps.image-tag.outputs.TAG }}
        run: docker build --file Dockerfile --tag "${{ secrets.DOCKERHUB_USERNAME }}/todo-boot:$TAG" .
      - name: Login To Docker Hub
        uses: docker/login-action@v3
        with:
          # 외부에 공개되면 안되는 정보를 Github의 Secrets and Variables에 저장
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - name: Push the Docker Image
        env:
          TAG: ${{ steps.image-tag.outputs.TAG }}
        run: docker push "${{ secrets.DOCKERHUB_USERNAME }}/todo-boot:$TAG"
      # latest push 하기
      - name: Tag Image as latest
        env:
          TAG: ${{ steps.image-tag.outputs.TAG }}
        run: |
          docker tag "${{ secrets.DOCKERHUB_USERNAME }}/todo-boot:$TAG" \
          "${{ secrets.DOCKERHUB_USERNAME }}/todo-boot:latest"
      - name: Push latest
        run: docker push "${{ secrets.DOCKERHUB_USERNAME }}/todo-boot:latest"
```

<br>

- `gradle-ci.yml`
```shell
name: Java CI with Gradle

on:
#  push:
#    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  # 소스코드의 테스트를 진행하는 Job
  test:
    # 이 Job은 Ubuntu 최신 LTS에서 실행된다.
    runs-on: ubuntu-latest
    # 이 Job의 개별 단계
    steps:
      # 소스코드 가져오기
      - name: Checkout Source
        # 이미 만들어진 Action을 쓸 경우 uses
        uses: actions/checkout@v4
      # JDK 설정하기
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        # Action에 전달할 인자들
        with:
          java-version: '17'
          distribution: 'temurin'
      # Gradle 설정하기
      - name: Setup Gradle
        uses: gradle/actions/setup-gradle@v3.1.0
      # Gradle Wrapper로 Test 진행
      - name: Test with Gradle Wrapper
        # 그냥 실행하는 명령의 경우 run
        run: ./gradlew test
  # 서로 다른 Job은 서로 다른 컴퓨터에서 실행한다고 가정하고 작성해주자.
  boot-jar:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Source
        uses: actions/checkout@v4
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Setup Gradle
        uses: gradle/actions/setup-gradle@v3.1.0
      # Gradle Wrapper로 JAR 파일 생성
      - name: Create Boot JAR with Gradle Wrapper
        run: ./gradlew bootJar
      # JAR 파일을 Artifact로 업로드
      - name: Upload JAR
        uses: actions/upload-artifact@v4
        # 어떤 파일을 업로드 할건지
        with:
          name: artifact
          path: build/libs/*.jar
```

</details>

---

## CI/CD

- 2024.04.01 ~ `21주차`

- 04.01 - GitHub Actions를 활용한 CI (gradle-ci.yml)
- 04.02 - GitHub Actions + Docker를 활용한 CI (docker-image.yml)




