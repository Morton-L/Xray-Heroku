#为映像文件构建过程指定基准镜像
FROM alpine:latest
#安装非全局依赖软件,包名为.build-deps,软件为ca-certificates curl unzip
RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip
#添加configure.sh到/
ADD configure.sh /configure.sh
#给sh文件添加可执行权限
RUN chmod +x /configure.sh
#执行sh文件
CMD /configure.sh
#删除非全局依赖包.build-deps
RUN apk del .build-deps
