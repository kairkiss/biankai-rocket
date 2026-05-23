# 卞恺rocket v1.1.1

## 更新摘要

- 修复 Simple Mode 单首页触发 NavigationBar 红屏的问题。
- 开发者密码改为集中 hash 校验的 `114514`。
- 增加 Expert Mode 返回普通模式入口，退出时同步关闭开发者模式。
- 新增 SimpleProxiesView，普通模式节点页只保留节点选择和测速。
- 普通订阅详情页增加删除订阅，并补充二次确认和当前订阅提示。
- 替换应用 Logo，更新桌面图标、首页和 About 品牌展示。
- 增加卞恺 rocket 默认分流模板；简化节点订阅会自动补默认代理组和规则，完整配置默认不覆盖。
- 加强 Simple Mode 空数据、错误输入和配置缺失时的兜底显示。

## 稳定性边界

- VPN Service、Mihomo 核心、订阅解析、节点切换、规则和日志底层逻辑未重写。
- 默认分流模板只补简化配置，不覆盖已有 `proxy-groups` 与 `rules` 的完整配置。

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
