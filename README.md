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

## 测试你的编译器

通常情况下, 你可以使用如下的步骤测试你的编译器:

* 使用 `git` 将你的编译器拉取到镜像中, 或者将你本地的编译器目录挂载到镜像中.
* 进入镜像中的目录, 使用 Make/CMake/Cargo 编译你的编译器.
* 使用你的编译器将 SysY 的源文件编译到 Eeyore/Tigger/RISC-V 汇编.

对于生成的 Eeyore 程序:

* 使用 `minivm Eeyore程序文件` 运行你的 Eeyore 程序, 并收集程序的标准输出和返回值.
* 将结果和预期结果进行对比.

对于生成的 Tigger 程序:

* 使用 `minivm -t Tigger程序文件` 运行你的 Tigger 程序, 并收集程序的标准输出和返回值.
* 将结果和预期结果进行对比.

对于生成的 RISC-V 汇编:

* 使用 `riscv32-unknown-linux-gnu-gcc RISC-V汇编文件 -o 可执行文件 -static -L/root/sysy-runtime-lib -lsysy` 生成可执行文件.
* 使用 `qemu-riscv32-static 可执行文件` 运行你的 RISC-V 程序, 并收集程序的标准输出和返回值.
* 将结果和预期结果进行对比.
