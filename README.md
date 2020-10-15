# README

Project for 42 Madrid on docker, nginx, debian, wordpress.

xvan-ham@student.42madrid.com

Build this docker image using:
`docker build -t ft_server .` which will build the docker image using the Dockerfile in the current directory, tagging said image as *ft_server*.

Run the image (as a new container) using:
`docker run --rm -p 80:80 -p 443:443 -it ft_server /bin/bash` which will run the container with the specified port mapping (80 for default server, 443 for ssl verification) and an interactive terminal using the `/bin/bash` command (/bin/bash can be omitted from this command, it will default to it); optionally name the container using `--name <container name>` switch.

By default, ft_server will run with **autoindexing** **ON**.
To change, type `autoindex_off`, use `autoindex_on` to turn on again.

Docker enables you to run in a controlled isolated environment, meaning anyone who runs a program within the docker environment will be able to do so in **exaclty** the same environment - therefore no machine-specific problems can arise. It can do so without without needing a full VM (Virtual Machine), which makes Docker more lightweight (Docker uses the host OS to manage hardware rather than a VM splitting hardware use). As a note, by default Docker will kill the container when the **docker run** process is complete.

### Useful Commands for ft_server
* **docker image ls** - *lists* current docker images.
* **docker image rm <image\_name>** - **deletes** specified docker image.
* **docker build -t <image\_name>** .. - **builds** docker image with the specified name in specified (Dockerfile) location (i.e. *..*).
* **docker run -p 80:80 <image\_name>** - **runs** the docker image and **forwards specified port** the specified port (<host> : <container>).
* **docker run -it --rm -p 80:80 <image\_name>** - **-i** interactive; **-t** pseudo-terminal.
* **docker rmi $(docker images --filter "dangling=true" -q --no-trunc)** - **deletes** all dangling **images**
* **docker exec -it <container id> bin/bash** - **get into container** defined by "container id" with an interactive (**-i**) terminal (**-t**).
* **docker run *-it* <image\_name> */bin/bash* **- **runs** the docker image with an **interactive bash terminal**. 
* **docker ps** - **list** containers which are currently running.
* **docker ps -a** - **list** containers which are currently running **and** recently closed.
* **docker run ubuntu** ***tail -f /dev/null*** - *runs* ubuntu in the foreground **"forever"**. This container needs to be **killed** manually.
* **docker **kill** <container id>** - **kills** the specified container.
* **docker **stop** <container id>** - **stops** the specified running container (with SIGTERM) and gracefully shuts the container down. If Docker fails to terminate this container within 10s, the main process inside the container will receive a SIGKILL (forcefully *kills* the container).
* **docker run *-d* -p 80:80 nginx** - runs docker image with mapped ports (as specified before) **but** also uses *detach* flag (can use **--detach** instead of **-d** as well). This means that the process will not "hang" as it did before, nor will it kill the container when the process is exited (by pressing **Ctrl** + **C** for instance) - instead the process runs in the background and the container must be killed manually (so the server will be up until the corresponding container is killed). 
* **docker run *--name* server -p 80:80 nginx** - runs docker image with mapped ports (as specified before) *but* **specifies image name** so that the name can be used in Docker commands instead of the container_id.
* **docker run *--rm* -p 80:80 nginx** -The --rm flag is there to tell the Docker Daemon to **clean up** the **container** and remove the file system after the container exits.
* Dockerfile: **RUN <command>** - runs the command within the container during image build. This is useful to say create containers with pre-installed programs (specified using RUN commands) without explicitly needing to install them everytime the container is run.
* Dockerfile: **COPY <file on host> <directory within container>** - **copies** file(s) from host to container.
* **curl -s https://api.wordpress.org/secret-key/1.1/salt/** - **generate** secret **keys** for **WordPress**.

### Simple nginx container exercise

This simple exercise will familiarise the reader with the basics of Docker applied to the Nginx web-server. This mini-exercise is based on the YouTuber **codedamn's** Docker tutorial series, which I recommend any reader getting started with Docker.

* Run docker (for 42 students, use **init\_docker.sh** from the **42toolbox**).
* Exec: **docker pull nginx** to install nginx.
* Exec: **docker run nginx** to run the nginx container.

At this stage you will notice that the console seems to be in an ongoing process.

* Open a new console (don't close the current one).
* Exec: **docker ps** to see a list on currently running containers.
* Copy the **container id** of the nginx container.
* Exec: **docker exec -it <container id>**.

You will notice the console location changes (e.g. **root@9761e41241d5**), we are now inside of the container.

* Exec: **apt update**.
* Exec: **apt install curl** to install curl (tool to transfer data from or to a server - see man).
* Exec: **curl http://localhost**.

This returns the following:

```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

This proves that the container is running a simple webpage. **However**, should you open your chosen web-browser and visit: **http://localhost/**, you will notice an error message is produced i.e. "This site can’t be reached - localhost refused to connect."

**Reason?** It's not available to the host (you).
By default, nginx is mapped to port 80 on docker.

What we need to do is map a local port to a docker port, we do this using the **-p** flag (**-p <host port> : <docker port>**).
Therefore, instead of using: **docker run nginx**, we need to use:
**docker run -p 80:80 nginx** - this will run nginx with host-port 80 (**80** : 80) mapped to docker-port 80 (80 : **80**).

Doing so will show you the contents of the nginx welcome web-page.
If you browse your ip-address: on Mac: **ifconfig | grep "inet "** (e.g. 127.0.0.1 or 192.X.X.X).
Entering your private ip-address on the web-browser will also show you the contents of the container - **this means anyone on your network can view this page by entering your ip-address**.

If you wish to **only** have the web-page visible to your localhost, you need to run the following:
**docker run -p 127.0.0.1:80:80 nginx** - now it should **only** work with *http://localhost** or *127.0.0.1*.
