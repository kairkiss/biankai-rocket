<div>

[**简体中文**](README_zh_CN.md)

</div>

## 卞恺rocket

[![License](https://img.shields.io/github/license/kairkiss/biankai-rocket?style=flat-square)](LICENSE)

Personal Android proxy client focused on a compact Simple Mode and a full Expert Mode.

This project remains open source under GPLv3. It is derived from the GPLv3 project [chen08209/FlClash](https://github.com/chen08209/FlClash); the original license and copyright notices are preserved.

## Features

✈️ Android Simple Mode for daily subscription, node, mode, and proxy control

💻 Expert Mode keeps the full advanced management UI

💡 Light/dark iOS-style card layout with blue emphasis

☁️ Existing Mihomo, subscription, rule, log, and VPN paths stay intact

✨ GPLv3 source and modification notes remain in this repository

## Use

### Linux

⚠️ Make sure to install the following dependencies before using them

   ```bash
    sudo apt-get install libayatana-appindicator3-dev
    sudo apt-get install libkeybinder-3.0-dev
   ```

### Android

Support the following actions

   ```bash
    com.biankai.rocket.action.START
    
    com.biankai.rocket.action.STOP
    
    com.biankai.rocket.action.TOGGLE
   ```

## Download

Use the release assets published from this repository.

## Build

1. Update submodules
   ```bash
   git submodule update --init --recursive
   ```

2. Install `Flutter` and `Golang` environment

3. Build Application

    - android

        1. Install  `Android SDK` ,  `Android NDK`

        2. Set `ANDROID_NDK` environment variables

        3. Run Build script

           ```bash
           dart .\setup.dart android
           ```

    - windows

        1. You need a windows client

        2. Install  `Gcc`，`Inno Setup`

        3. Run build script

           ```bash
           dart .\setup.dart windows --arch <arm64 | amd64>
           ```

    - linux

        1. You need a linux client

        2. Run build script

           ```bash
           dart .\setup.dart linux --arch <arm64 | amd64>
           ```

    - macOS

        1. You need a macOS client

        2. Run build script

           ```bash
           dart .\setup.dart macos --arch <arm64 | amd64>
           ```
