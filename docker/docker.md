# [王孝东的个人空间](https://scm-git.github.io/)
## [Docker](https://www.docker.com/)
### 1. [Install](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-centos-7)
```bash
# curl -fsSL https://get.docker.com/ | sh
# curl -fsSL https://get.docker.com/ | sh
# sudo systemctl status docker
# docker help
# docker COMMAND --help
# docker info
# docker run hello-world
# docker search centos
# docker pull centos
# docker run centos
# docker images
# docker run -it centos
# docker commit -m "your comments" -a "author name" container-id repository/new_image_name
# docker ps
# docker ps -a
# docker ps -l
# docker stop container-id
// push docker imamge, need login first
# docker login -u docker-registry-username
# docker push docker-registry-username/docker-image-name

```