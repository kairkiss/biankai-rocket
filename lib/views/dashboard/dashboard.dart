import 'package:biankai_rocket/common/common.dart';
import 'package:biankai_rocket/controller.dart';
import 'package:biankai_rocket/enum/enum.dart';
import 'package:biankai_rocket/models/models.dart';
import 'package:biankai_rocket/providers/providers.dart';
import 'package:biankai_rocket/views/application_setting.dart';
import 'package:biankai_rocket/views/config/rules.dart';
import 'package:biankai_rocket/views/dashboard/simple_dashboard.dart';
import 'package:biankai_rocket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expertMode = ref.watch(
      appSettingProvider.select((state) => state.expertMode),
    );
    return expertMode ? const _ExpertDashboardView() : const SimpleDashboard();
  }
}

class _ExpertDashboardView extends ConsumerWidget {
  const _ExpertDashboardView();

  String _modeLabel(Mode mode) {
    return switch (mode) {
      Mode.rule => 'Rule',
      Mode.global => 'Global',
      Mode.direct => 'Direct',
    };
  }

  String _currentNode({
    required List<Group> groups,
    required Map<String, String> selectedMap,
    String? currentGroupName,
  }) {
    if (groups.isEmpty) return '--';
    final group = currentGroupName != null
        ? groups.getGroup(currentGroupName)
        : null;
    final currentGroup = group ?? groups.first;
    final selectedName = selectedMap[currentGroup.name] ?? '';
    final name = currentGroup.getCurrentSelectedName(selectedName);
    return name.isEmpty ? '--' : name;
  }

  Traffic _lastTraffic(FixedList<Traffic> traffics) {
    final list = traffics.list;
    if (list.isEmpty) return const Traffic();
    return list.last;
  }

  Future<void> _toggleProxy(WidgetRef ref, bool isStart) async {
    await appController.updateStatus(!isStart, isInit: !ref.read(initProvider));
  }

  void _openPage(BuildContext context, PageLabel pageLabel) {
    appController.toPage(pageLabel);
  }

  void _openRules(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddedRulesView()));
  }

  void _openSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ApplicationSettingView()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStart = ref.watch(isStartProvider);
    final currentProfile = ref.watch(currentProfileProvider);
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    final traffics = ref.watch(trafficsProvider);
    final lastTraffic = _lastTraffic(traffics);
    final totalTraffic = ref.watch(totalTrafficProvider);
    final runTime = ref.watch(runTimeProvider);
    final groups = ref.watch(groupsProvider);
    final selectedMap = ref.watch(selectedMapProvider);
    final statusText = isStart ? '已连接' : '未连接';
    final currentNode = _currentNode(
      groups: groups,
      selectedMap: selectedMap,
      currentGroupName: currentProfile?.currentGroupName,
    );

    return CommonScaffold(
      title: appName,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(statusText: statusText, isStart: isStart),
                const SizedBox(height: 22),
                Center(
                  child: _PowerButton(
                    isStart: isStart,
                    onPressed: () => _toggleProxy(ref, isStart),
                  ),
                ),
                const SizedBox(height: 22),
                _StatusPanel(
                  items: [
                    _StatusItem('当前配置', currentProfile?.label ?? '--'),
                    _StatusItem('当前模式', _modeLabel(mode)),
                    _StatusItem('当前节点', currentNode),
                    _StatusItem('上传速度', '${lastTraffic.up.traffic.show}/s'),
                    _StatusItem('下载速度', '${lastTraffic.down.traffic.show}/s'),
                    _StatusItem('今日流量', totalTraffic.desc),
                    _StatusItem(
                      '运行时长',
                      isStart ? utils.getTimeText(runTime) : '--',
                    ),
                    _StatusItem('连接状态', statusText),
                  ],
                ),
                const SizedBox(height: 18),
                _EntryList(
                  entries: [
                    _EntryItem(
                      icon: Icons.list_alt_outlined,
                      title: '配置',
                      subtitle: '订阅导入、更新与切换',
                      onTap: () => _openPage(context, PageLabel.profiles),
                    ),
                    _EntryItem(
                      icon: Icons.swap_vert_circle_outlined,
                      title: '代理',
                      subtitle: '代理组、节点选择与延迟测试',
                      onTap: () => _openPage(context, PageLabel.proxies),
                    ),
                    _EntryItem(
                      icon: Icons.rule_folder_outlined,
                      title: '规则',
                      subtitle: '规则模式与自定义规则',
                      onTap: () => _openRules(context),
                    ),
                    _EntryItem(
                      icon: Icons.subject_outlined,
                      title: '日志',
                      subtitle: '查看运行日志与导出记录',
                      onTap: () => _openPage(context, PageLabel.logs),
                    ),
                    _EntryItem(
                      icon: Icons.settings_outlined,
                      title: '设置',
                      subtitle: '常规、网络、外观与高级选项',
                      onTap: () => _openSettings(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String statusText;
  final bool isStart;

  const _Header({required this.statusText, required this.isStart});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appName,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                statusText,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isStart
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isStart
                ? context.colorScheme.primary
                : context.colorScheme.outline,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _PowerButton extends StatelessWidget {
  final bool isStart;
  final VoidCallback onPressed;

  const _PowerButton({required this.isStart, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isStart
        ? context.colorScheme.primary
        : context.colorScheme.surfaceContainerHigh;
    final foregroundColor = isStart
        ? context.colorScheme.onPrimary
        : context.colorScheme.onSurface;
    return Semantics(
      button: true,
      label: isStart ? '停止代理' : '开启代理',
      child: InkWell(
        borderRadius: BorderRadius.circular(80),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: commonDuration,
          width: 156,
          height: 156,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withValues(alpha: 0.14),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.power_settings_new_rounded,
                size: 46,
                color: foregroundColor,
              ),
              const SizedBox(height: 10),
              Text(
                isStart ? '停止代理' : '开启代理',
                style: context.textTheme.titleMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusItem {
  final String label;
  final String value;

  const _StatusItem(this.label, this.value);
}

class _StatusPanel extends StatelessWidget {
  final List<_StatusItem> items;

  const _StatusPanel({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final columns = constraints.maxWidth >= 520 ? 4 : 2;
          final spacing = 10.0;
          final width =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final item in items)
                SizedBox(
                  width: width,
                  child: _StatusTile(item: item),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final _StatusItem item;

  const _StatusTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.value.isEmpty ? '--' : item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _EntryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _EntryList extends StatelessWidget {
  final List<_EntryItem> entries;

  const _EntryList({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (final entry in entries) ...[
            ListTile(
              leading: Icon(entry.icon, color: context.colorScheme.primary),
              title: Text(entry.title),
              subtitle: Text(entry.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: entry.onTap,
            ),
            if (entry != entries.last)
              Divider(
                height: 1,
                indent: 56,
                color: context.colorScheme.outlineVariant,
              ),
          ],
        ],
      ),
    );
  }
}
