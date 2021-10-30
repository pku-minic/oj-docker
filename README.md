# 评测机环境的 Docker 镜像

该仓库包含一个可用于构建评测机环境的 `Dockerfile`, 你可以在此基础上构建一个与评测机环境所使用的工具链版本完全一致的 Docker 镜像.

> 注: 该 Dockerfile 总会获取最新的 Rust 工具链以及 MiniVM, 所以上述两个工具的版本可能会比评测机中的版本更新.

## 构建 Docker 镜像

首先确保你的电脑中安装了 Docker, 然后在仓库的根目录执行如下命令 (如果你使用的是 Linux 操作系统, 则你需要 `root` 权限):

```sh
docker build -t oj-docker .
```

稍等片刻, 镜像 `oj-docker` 即可构建完成.

## 使用 Docker 镜像

你可以使用:

```sh
docker run -it --rm oj-docker bash
```

进入镜像中的 shell.

当然, 你也可以选择将你本地的目录挂在到 Docker 中:

```sh
docker run -it --rm -v 本地路径:容器中的路径 oj-docker bash
```

详情请参考 Docker 的[官方文档](https://docs.docker.com/engine/reference/commandline/run/#mount-volume--v---read-only).
