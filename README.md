# Quick Start

Build the docker containers with

```sh 
docker compose build
```

Start the containers with

```sh
docker compose up
```

You can connect to a running container with:

```sh 
docker exec -u root -it <container-id> sh
```

where `<container-id>` can be found by running `docker ps`

Once the container is running, you should be able to visit `localhost/home/` and begin debugging
