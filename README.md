# docker-router lab

## 1. 깃 허브에서 레포 클론하기

#### git clone

## 2. 도커 이미지 만들기
#### docker build -t yslee-router:1 .

## 3. 도커 컨테이너 실행하기
#### make all

## 4. 도커 컨테이너 내부에서 RIP 설정하기
#### docker attach R1
#### docker attach R2
#### docker attach R3
#### docker attach R4

## 5. 도커 컨테이너에서 vtysh 설정하기

#### vtysh
#### enable
#### configure terminal
#### router rip
#### network 192.168.x.0/24
#### end
#### end
#### write memory
#### show ip rip
#### ping dest_ip
