import 'package:biankai_rocket/common/common.dart';
import 'package:biankai_rocket/controller.dart';
import 'package:biankai_rocket/enum/enum.dart';
import 'package:biankai_rocket/models/models.dart';
import 'package:biankai_rocket/providers/providers.dart';
import 'package:biankai_rocket/views/proxies/common.dart';
import 'package:biankai_rocket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleProxiesView extends ConsumerWidget {
  const SimpleProxiesView({super.key});

  Group? _currentGroup(List<Group> groups, String? currentGroupName) {
    if (groups.isEmpty) return null;
    if (currentGroupName == null || currentGroupName.isEmpty) {
      return groups.first;
    }
    return groups.getGroup(currentGroupName) ?? groups.first;
  }

  String _selectedName(Group group, Map<String, String> selectedMap) {
    final selectedName = selectedMap[group.name] ?? '';
    final name = group.getCurrentSelectedName(selectedName);
    return name.isEmpty ? '--' : name;
  }

  Future<void> _retry() async {
    await appController.safeRun(
      () => appController.applyProfile(force: true),
      title: '重新加载节点',
    );
  }

  Future<void> _test(Group group) async {
    await appController.safeRun(
      () => delayTest(group.all, group.testUrl),
      title: '节点测速',
    );
  }

  Future<void> _selectProxy(
    BuildContext context,
    WidgetRef ref,
    Group group,
    Proxy proxy,
  ) async {
    if (!(group.type == GroupType.Selector || group.type.isComputedSelected)) {
      context.showNotifier('当前代理组不支持手动选择');
      return;
    }
    final currentProxyName = ref.read(getProxyNameProvider(group.name));
    final nextProxyName = group.type.isComputedSelected
        ? currentProxyName == proxy.name
              ? ''
              : proxy.name
        : proxy.name;
    appController.updateCurrentSelectedMap(group.name, nextProxyName);
    appController.changeProxyDebounce(group.name, nextProxyName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider(LoadingTag.proxies));
    final currentProfile = ref.watch(currentProfileProvider);
    final groups = ref.watch(groupsProvider);
    final selectedMap = ref.watch(selectedMapProvider);
    final group = _currentGroup(groups, currentProfile?.currentGroupName);
    final selectedName = group == null
        ? '--'
        : _selectedName(group, selectedMap);

    return CommonScaffold(
      title: '节点',
      actions: [
        if (group != null)
          IconButton(
            tooltip: '一键测速',
            onPressed: isLoading ? null : () => _test(group),
            icon: const Icon(Icons.network_check_rounded),
          ),
      ],
      body: Stack(
        children: [
          if (currentProfile == null)
            _SimpleEmptyState(
              icon: Icons.cloud_off_outlined,
              title: '暂无订阅',
              message: '请先导入订阅后再选择节点。',
              actionLabel: '重试',
              onPressed: _retry,
            )
          else if (group == null)
            _SimpleEmptyState(
              icon: Icons.hub_outlined,
              title: '暂无节点',
              message: '没有读取到代理组或节点，请更新订阅后重试。',
              actionLabel: '重新加载',
              onPressed: _retry,
            )
          else
            ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              itemCount: group.all.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                if (index == 0) {
                  return _GroupHeader(
                    groups: groups,
                    group: group,
                    selectedName: selectedName,
                    onChanged: (name) {
                      if (name == null) return;
                      appController.updateCurrentGroupName(name);
                    },
                    onTest: () => _test(group),
                  );
                }
                final proxy = group.all[index - 1];
                return _ProxyTile(
                  group: group,
                  proxy: proxy,
                  selected: selectedName == proxy.name,
                  onTap: () => _selectProxy(context, ref, group, proxy),
                );
              },
            ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final List<Group> groups;
  final Group group;
  final String selectedName;
  final ValueChanged<String?> onChanged;
  final VoidCallback onTest;

  const _GroupHeader({
    required this.groups,
    required this.group,
    required this.selectedName,
    required this.onChanged,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return _SimplePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('当前节点', style: context.textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(
            selectedName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: group.name,
                  decoration: const InputDecoration(labelText: '当前代理组'),
                  items: [
                    for (final item in groups)
                      DropdownMenuItem(
                        value: item.name,
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                tooltip: '一键测速',
                onPressed: onTest,
                icon: const Icon(Icons.network_check_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProxyTile extends ConsumerWidget {
  final Group group;
  final Proxy proxy;
  final bool selected;
  final VoidCallback onTap;

  const _ProxyTile({
    required this.group,
    required this.proxy,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delay = ref.watch(
      getDelayProvider(proxyName: proxy.name, testUrl: group.testUrl),
    );
    return Material(
      color: selected
          ? context.colorScheme.primaryContainer
          : context.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  proxy.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _DelayBadge(delay: delay),
            ],
          ),
        ),
      ),
    );
  }
}

class _DelayBadge extends StatelessWidget {
  final int? delay;

  const _DelayBadge({required this.delay});

  @override
  Widget build(BuildContext context) {
    if (delay == 0) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    final text = delay == null
        ? '--'
        : delay! > 0
        ? '${delay}ms'
        : '超时';
    return Text(
      text,
      style: context.textTheme.labelMedium?.copyWith(
        color: delay == null
            ? context.colorScheme.onSurfaceVariant
            : utils.getDelayColor(delay!),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SimplePanel extends StatelessWidget {
  final Widget child;

  const _SimplePanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

class _SimpleEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  const _SimpleEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: context.colorScheme.onSurfaceVariant),
            const SizedBox(height: 14),
            Text(title, style: context.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(onPressed: onPressed, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
