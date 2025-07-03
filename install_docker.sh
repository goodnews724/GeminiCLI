#!/bin/bash

# Docker 설치 스크립트 for Ubuntu
# 실행 방법: chmod +x install_docker.sh && ./install_docker.sh

set -e

echo "=== Ubuntu Docker 설치 시작 ==="

# 시스템 업데이트
echo "1. 시스템 패키지 업데이트 중..."
sudo apt update
sudo apt upgrade -y

# 필요한 패키지 설치
echo "2. 필수 패키지 설치 중..."
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Docker GPG 키 추가
echo "3. Docker GPG 키 추가 중..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Docker 저장소 추가
echo "4. Docker 저장소 추가 중..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 패키지 목록 업데이트
echo "5. 패키지 목록 업데이트 중..."
sudo apt update

# Docker 설치
echo "6. Docker 설치 중..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker 서비스 시작 및 부팅 시 자동 시작 설정
echo "7. Docker 서비스 설정 중..."
sudo systemctl start docker
sudo systemctl enable docker

# 현재 사용자를 docker 그룹에 추가 (sudo 없이 docker 명령 사용 가능)
echo "8. 사용자를 docker 그룹에 추가 중..."
sudo usermod -aG docker $USER

# Docker 버전 확인
echo "9. Docker 설치 확인 중..."
docker --version
docker compose version

echo ""
echo "=== Docker 설치 완료! ==="
echo ""
echo "주의사항:"
echo "- docker 그룹 권한을 적용하려면 로그아웃 후 다시 로그인하세요."
echo "- 또는 'newgrp docker' 명령을 실행하여 즉시 적용할 수 있습니다."
echo ""
echo "설치 확인:"
echo "- Docker 버전: $(docker --version)"
echo "- Docker Compose 버전: $(docker compose version)"
echo ""
echo "테스트 실행:"
echo "sudo docker run hello-world"
