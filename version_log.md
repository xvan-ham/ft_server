#Version Log

## v1.02
* Added autoindexing.
* Added scripts to switch autoindexing on / off.
* Added script location to $PATH variables so they can be executed from anywhere.

## v1.01
* Tweaked echo test in Dockerfile.
* Changed index page, included a link to the wordpress page.

## v1.00
This version meets project specifications. Wordpress has been integrated and at first-time access, the user (admin) will be prompted to setup the wordpress web-page and customize to liking.
This version requires launching with interactice terminal (**-it**) and mapping ports 80 (default) and 443 (for ssl) (-p 80\:80 -p 443\:443).
`docker build -t ft_server` Executed from the directory containing the Dockerfile.
`docker run --rm -p 80:80 -p 443:443 -it ft_server /bin/bash` to run the docker image *ft_server* as a new container.
* Added wordpress integration.
* Setup php to correctly connect with wordpress.
* Re-ordered and annotated Dockerfile.

## v0.7d
Fist steps towards WordPress implementation [dev update].
* Added installation instructions for WordPress and some common dependencies.
* Added *keys* file with unique WordPress keys. This is a temporary file until the WordPress config file is ready.

### v0.5
This version requires launching with interactice terminal (**-it**) and mapping ports 80 (default) and 443 (for ssl) (-p 80\:80 -p 443\:443).
Host a simple html local web-page with PHP database and self-signed ssl key (https) using nginx.
Pull this commit in order to use *ft_server* without WordPress.
* Dockerfile now hosts a basic html web-page with ssl (self-signed) i.e. https://localhost
* Dockerfile automatically initiates necessary services to host the web-page when container is created.

#### v0.15
* Added new *useful commands*.
* Added *index.html* file, a basic html web-page (visible on local-host and private-ip).
* Added *nginx.conf* file to replace default one.
* Corrected typos on existing README entries.
This version test basic nginx capability.
Build with:`docker build -t ft_server` - tag image as *ft_server*.
Run with: `docker run --rm --name ft_container -p 80:80 -d ft_server` - optionally run in detached mode (*-d*).
Visit: http://localhost.
#### v0.1
* Created git repo: "https://github.com/xvan-ham/ft_server".
* Created and annotated ***README.md*** file with useful commands and a simple Docker nginx exercise.
