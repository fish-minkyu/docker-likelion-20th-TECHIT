# Docker & Docker Image workflow

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
<summary><strong>Docker을 이용한 배포</strong></summary>

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


</details>

---

## CI/CD

- 2024.04.01 ~ `21주차`

- 04.01 - GitHub Actions를 활용한 CI (gradle-ci.yml)
- 04.02 - GitHub Actions + Docker를 활용한 CI (docker-image.yml)




