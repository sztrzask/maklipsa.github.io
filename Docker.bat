docker rm -f indexOutOfRange
docker run -it -p 4000:4000 -v //c/src/IndexOutOfRange/:/site --name indexOutOfRange andredumas/github-pages serve --watch --force_polling