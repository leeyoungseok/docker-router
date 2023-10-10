.DEFAULT_GOAL := all
.PHONY: create clean clean-nw all_check check

FLAGS := --sysctl net.ipv4.ip_forward=1 --privileged
FORCE_FLAG :=

UNAME := $(shell uname)
ifeq ($(UNAME),Linux)
	FLAGS += -e DISPLAY=$$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix
endif
ifeq ($(UNAME),Darwin)
	FLAGS += -e DISPLAY=docker.for.mac.localhost:0
endif

all: all_check
	$(MAKE) create NAME=R1 NW=nw56 IP=192.168.56.2
	$(MAKE) create NAME=R2 NW=nw56 IP=192.168.56.3
	$(MAKE) create NAME=R3 NW=nw57 IP=192.168.57.2
	$(MAKE) create NAME=R4 NW=nw57 IP=192.168.57.3
	docker network connect nw58 R2 --ip=192.168.58.2
	docker network connect nw58 R3 --ip=192.168.58.3

create:
	docker run -itd --name ${NAME} --hostname=${NAME} $(FLAGS) --net=${NW} --ip=${IP} yslee-router:1 
	
clean:
	-docker rm R1 --force
	-docker rm R2 --force
	-docker rm R3 --force
	-docker rm R4 --force
	$(MAKE) clean-nw NW=nw56
	$(MAKE) clean-nw NW=nw57
	$(MAKE) clean-nw NW=nw58

clean-nw:
	-docker network rm ${NW} 2> /dev/null || true

all_check:
	$(MAKE) check NW=nw56 SUBNET=192.168.56.0/24
	$(MAKE) check NW=nw57 SUBNET=192.168.57.0/24
	$(MAKE) check NW=nw58 SUBNET=192.168.58.0/24

check:
	(docker network inspect ${NW} 2> /dev/null | grep ${SUBNET}) || \
	($(MAKE) clean-nw NW=${NW} && docker network create --subnet=${SUBNET} ${NW})
