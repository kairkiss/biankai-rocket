import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:biankai_rocket/common/common.dart';
import 'package:biankai_rocket/controller.dart';
import 'package:biankai_rocket/enum/enum.dart';
import 'package:biankai_rocket/models/models.dart';
import 'package:biankai_rocket/providers/providers.dart';
import 'package:biankai_rocket/state.dart';
import 'package:biankai_rocket/views/proxies/proxies.dart';
import 'package:biankai_rocket/views/simple/simple_profiles.dart';
import 'package:biankai_rocket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleDashboard extends ConsumerWidget {
  const SimpleDashboard({super.key});

  String _modeLabel(Mode mode) {
    return switch (mode) {
      Mode.rule => '规则',
      Mode.global => '全局',
      Mode.direct => '直连',
    };
  }

  Traffic _lastTraffic(FixedList<Traffic> traffics) {
    final list = traffics.list;
    return list.isEmpty ? const Traffic() : list.last;
  }

  String _currentNode({
    required List<Group> groups,
    required Map<String, String> selectedMap,
    String? currentGroupName,
  }) {
    if (groups.isEmpty) return '--';
    final group = currentGroupName == null
        ? null
        : groups.getGroup(currentGroupName);
    final currentGroup = group ?? groups.first;
    final selectedName = selectedMap[currentGroup.name] ?? '';
    final name = currentGroup.getCurrentSelectedName(selectedName);
    return name.isEmpty ? '--' : name;
  }

  Future<void> _open(BuildContext context, Widget view) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => view));
  }

  Future<void> _toggle(WidgetRef ref, bool isStart) async {
    await appController.updateStatus(!isStart, isInit: !ref.read(initProvider));
  }

  Future<void> _unlockExpertMode(BuildContext context, WidgetRef ref) async {
    final password = await globalState.showCommonDialog<String>(
      child: InputDialog(
        title: '开发者选项',
        labelText: '密码',
        obscureText: true,
        value: '',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入密码';
          }
          return null;
        },
      ),
    );
    if (password == null || !context.mounted) return;
    final digest = sha256.convert(utf8.encode(password)).toString();
    if (digest != expertModePasswordHash) {
      context.showNotifier('密码错误');
      return;
    }
    ref
        .read(appSettingProvider.notifier)
        .update(
          (state) => state.copyWith(expertMode: true, developerMode: true),
        );
    context.showNotifier('已进入专家模式');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStart = ref.watch(isStartProvider);
    final currentProfile = ref.watch(currentProfileProvider);
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    final groups = ref.watch(groupsProvider);
    final selectedMap = ref.watch(selectedMapProvider);
    final traffics = ref.watch(trafficsProvider);
    final totalTraffic = ref.watch(totalTrafficProvider);
    final lastTraffic = _lastTraffic(traffics);
    final networkState = ref.watch(networkDetectionProvider);
    final node = _currentNode(
      groups: groups,
      selectedMap: selectedMap,
      currentGroupName: currentProfile?.currentGroupName,
    );

    return CommonScaffold(
      title: appName,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SimpleHeader(isStart: isStart),
                const SizedBox(height: 18),
                _PowerCard(
                  isStart: isStart,
                  onPressed: () => _toggle(ref, isStart),
                ),
                const SizedBox(height: 14),
                _ModeCard(
                  mode: mode,
                  textBuilder: _modeLabel,
                  onChanged: appController.changeMode,
                ),
                const SizedBox(height: 14),
                _InformationCard(
                  profile: currentProfile?.realLabel ?? '--',
                  node: node,
                  upload: '${lastTraffic.up.traffic.show}/s',
                  download: '${lastTraffic.down.traffic.show}/s',
                  today: totalTraffic.desc,
                  onProfiles: () => _open(context, const SimpleProfilesView()),
                  onProxies: () => _open(context, const ProxiesView()),
                ),
                const SizedBox(height: 14),
                _ConnectionTestCard(
                  isLoading: networkState.isLoading,
                  ip: networkState.ipInfo?.ip,
                  onPressed: () {
                    ref.read(networkDetectionProvider.notifier).startCheck();
                  },
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => _unlockExpertMode(context, ref),
                  icon: const Icon(Icons.developer_mode_outlined),
                  label: const Text('开发者选项'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleHeader extends StatelessWidget {
  final bool isStart;

  const _SimpleHeader({required this.isStart});

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
                isStart ? '代理已开启' : '代理未开启',
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

class _PowerCard extends StatelessWidget {
  final bool isStart;
  final VoidCallback onPressed;

  const _PowerCard({required this.isStart, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final background = isStart
        ? context.colorScheme.primary
        : context.colorScheme.surfaceContainerHigh;
    final foreground = isStart
        ? context.colorScheme.onPrimary
        : context.colorScheme.onSurface;
    return Material(
      color: context.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(30),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 244,
          child: Center(
            child: AnimatedContainer(
              duration: commonDuration,
              width: 172,
              height: 172,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.shadow.withValues(alpha: 0.14),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.power_settings_new_rounded,
                    size: 48,
                    color: foreground,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isStart ? '停止' : '开启',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final Mode mode;
  final String Function(Mode mode) textBuilder;
  final ValueChanged<Mode> onChanged;

  const _ModeCard({
    required this.mode,
    required this.textBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('当前模式', style: context.textTheme.labelLarge),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<Mode>(
              showSelectedIcon: false,
              segments: [
                for (final item in Mode.values)
                  ButtonSegment(value: item, label: Text(textBuilder(item))),
              ],
              selected: {mode},
              onSelectionChanged: (value) => onChanged(value.first),
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  final String profile;
  final String node;
  final String upload;
  final String download;
  final String today;
  final VoidCallback onProfiles;
  final VoidCallback onProxies;

  const _InformationCard({
    required this.profile,
    required this.node,
    required this.upload,
    required this.download,
    required this.today,
    required this.onProfiles,
    required this.onProxies,
  });

  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      child: Column(
        children: [
          _OpenInfoRow(
            icon: Icons.cloud_outlined,
            label: '当前订阅',
            value: profile,
            onPressed: onProfiles,
          ),
          const Divider(height: 22),
          _OpenInfoRow(
            icon: Icons.hub_outlined,
            label: '当前节点',
            value: node,
            onPressed: onProxies,
          ),
          const Divider(height: 22),
          Row(
            children: [
              Expanded(
                child: _Metric(label: '上传', value: upload),
              ),
              Expanded(
                child: _Metric(label: '下载', value: download),
              ),
              Expanded(
                child: _Metric(label: '今日', value: today),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OpenInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onPressed;

  const _OpenInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: context.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ConnectionTestCard extends StatelessWidget {
  final bool isLoading;
  final String? ip;
  final VoidCallback onPressed;

  const _ConnectionTestCard({
    required this.isLoading,
    required this.ip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('连通性测试', style: context.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  ip ?? (isLoading ? '检测中' : '--'),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: const Icon(Icons.network_check_rounded),
            label: const Text('测试'),
          ),
        ],
      ),
    );
  }
}

class _SimpleCard extends StatelessWidget {
  final Widget child;

  const _SimpleCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(26),
      ),
      child: child,
    );
  }
}
