<div>

[**English**](README.md)

</div>

## 卞恺rocket

[![License](https://img.shields.io/github/license/kairkiss/biankai-rocket?style=flat-square)](LICENSE)

面向 Android 日常代理使用的个人客户端，默认提供精简 Simple Mode，并保留完整 Expert Mode。

本项目继续遵循 GPLv3 开源协议，派生自 GPLv3 项目 [chen08209/FlClash](https://github.com/chen08209/FlClash)，并保留原始许可证与版权说明。

## Features

✈️ Simple Mode 聚焦订阅、节点、模式和代理开关

💻 Expert Mode 保留完整高级管理页面

💡 浅色白灰、深色黑灰和蓝色强调的卡片式界面

☁️ 原有 Mihomo、订阅、规则、日志和 VPN 链路保持稳定

✨ 仓库保留 GPLv3 源码与修改说明

## Use

### Linux

⚠️ 使用前请确保安装以下依赖

   ```bash
    sudo apt-get install libayatana-appindicator3-dev
    sudo apt-get install libkeybinder-3.0-dev
   ```

### Android

支持下列操作

   ```bash
    com.biankai.rocket.action.START
    
    com.biankai.rocket.action.STOP
    
    com.biankai.rocket.action.TOGGLE
   ```

## Download

请使用本仓库发布的 release 资源。

## Build

1. 更新 submodules
   ```bash
   git submodule update --init --recursive
   ```

2. 安装 `Flutter` 以及 `Golang` 环境

3. 构建应用

    - android

        1. 安装  `Android SDK` ,  `Android NDK`

        2. 设置 `ANDROID_NDK` 环境变量

        3. 运行构建脚本

           ```bash
           dart .\setup.dart android
           ```

    - windows

        1. 你需要一个windows客户端

        2. 安装 `Gcc`，`Inno Setup`

        3. 运行构建脚本

           ```bash
           dart .\setup.dart windows --arch <arm64 | amd64>
           ```

    - linux

        1. 你需要一个linux客户端

        2. 运行构建脚本

           ```bash
           dart .\setup.dart linux --arch <arm64 | amd64>
           ```

    - macOS

        1. 你需要一个macOS客户端

        2. 运行构建脚本

           ```bash
           dart .\setup.dart macos --arch <arm64 | amd64>
           ```
