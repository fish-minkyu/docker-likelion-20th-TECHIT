#!/usr/bin/env bash

# 실행중인 컨테이너 확인
running=$(docker ps -a --format "{{.ID}}" --filter "name=todo-cd" | wc -l)
# 실행중인 컨테이너가 있을 경우,
if [ $running -ge 1 ]; then
  # 중단하고
  docker stop todo-cd
  # 삭제한다.
  docker rm todo-cd
fi

# 새 이미지를 가져오고
docker pull edujeeho/todo-boot:latest
# 실행한다.
docker run -d --name todo-cd -p 8080:8080 edujeeho/todo-boot:latest
