docker rm -f indexOutOfRange
docker run -d -p 4000:4000 -v //c/Users/szymon.warda/Documents/Kitematic/IndexOutOfRange/:/src --name indexOutOfRange jclagache/github-pages serve