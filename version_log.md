#Version Log

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
