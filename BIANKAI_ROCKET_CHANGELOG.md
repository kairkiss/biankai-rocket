# 卞恺rocket v1.0.0

## 来源

- 上游项目：chen08209/FlClash
- 许可证：GPLv3，保留原作者版权说明

## 修改摘要

- App 名称改为「卞恺rocket」。
- Android 包名改为 `com.biankai.rocket`。
- 修复改包名后 Android Manifest 仍使用相对组件名导致启动闪退的问题。
- 修复订阅下载 User-Agent 包含中文 App 名可能导致 HTTP 请求失败的问题。
- 补充处理冷启动时的 `clash://install-config` 配置导入链接。
- 首页改为简洁状态面板和大开关布局。
- 增加配置、代理、规则、日志、设置的集中入口。
- 主题改为浅色白/浅灰、深色黑/深灰、iOS 蓝强调色。
- 替换为本地生成的「卞恺 / rocket」占位图标。
- 日志页新增清空按钮。

## 保持未变

- VPN Service 未删除。
- Mihomo / ClashMeta 核心未修改。
- 订阅解析逻辑未修改。
- 节点切换逻辑未修改。
- 规则引擎未修改。
- 日志底层采集逻辑未修改。

# 卞恺rocket v1.1.0

## 更新摘要

- 默认启用面向日常使用的 Simple Mode。
- Simple Mode 首页保留代理总开关、当前订阅、当前节点、上下行速度、今日用量和规则模式切换。
- Simple Mode 提供订阅导入、订阅详情、节点选择和连通性测试入口。
- 增加开发者选项密码解锁入口，解锁后进入保留完整高级功能的 Expert Mode。
- 开发者密码校验集中在配置常量中，UI 组件不保存密码明文。
- 前台仓库地址与品牌文案切换到 `kairkiss/biankai-rocket`。
- Dart package 名称迁移到 `biankai_rocket`。

## 稳定性边界

- VPN Service、Mihomo 核心、订阅解析、节点切换、规则和日志底层逻辑未重写。
- Simple Mode 通过 UI 分层隐藏高级入口，Expert Mode 继续使用现有完整页面。
