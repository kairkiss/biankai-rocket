import 'package:biankai_rocket/common/common.dart';
import 'package:biankai_rocket/controller.dart';
import 'package:biankai_rocket/enum/enum.dart';
import 'package:biankai_rocket/models/models.dart';
import 'package:biankai_rocket/providers/database.dart';
import 'package:biankai_rocket/providers/providers.dart';
import 'package:biankai_rocket/state.dart';
import 'package:biankai_rocket/views/profiles/add.dart';
import 'package:biankai_rocket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleProfilesView extends ConsumerStatefulWidget {
  const SimpleProfilesView({super.key});

  @override
  ConsumerState<SimpleProfilesView> createState() => _SimpleProfilesViewState();
}

class _SimpleProfilesViewState extends ConsumerState<SimpleProfilesView> {
  void _showAddSheet() {
    showExtend(
      context,
      builder: (_, type) {
        return AdaptiveSheetScaffold(
          type: type,
          title: '导入订阅',
          body: AddProfileView(context: context),
        );
      },
    );
  }

  Future<void> _update(Profile profile) async {
    await appController.safeRun(
      () => appController.updateProfile(profile, showLoading: true),
      title: '更新订阅',
    );
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(profilesProvider);
    final currentProfileId = ref.watch(currentProfileIdProvider);
    final isLoading = ref.watch(loadingProvider(LoadingTag.profiles));
    return CommonScaffold(
      title: '订阅',
      floatingActionButton: CommonFloatingActionButton(
        onPressed: _showAddSheet,
        icon: const Icon(Icons.add_rounded),
        label: '导入订阅',
      ),
      body: Stack(
        children: [
          profiles.isEmpty
              ? Center(
                  child: FilledButton.icon(
                    onPressed: _showAddSheet,
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text('导入订阅'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: profiles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final profile = profiles[index];
                    return _ProfileCard(
                      profile: profile,
                      selected: profile.id == currentProfileId,
                      onSelect: () {
                        ref.read(currentProfileIdProvider.notifier).value =
                            profile.id;
                      },
                      onDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                SimpleProfileDetailsView(profileId: profile.id),
                          ),
                        );
                      },
                      onUpdate: profile.type == ProfileType.url
                          ? () => _update(profile)
                          : null,
                    );
                  },
                ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class SimpleProfileDetailsView extends ConsumerWidget {
  final int profileId;

  const SimpleProfileDetailsView({super.key, required this.profileId});

  Future<void> _update(Profile profile) async {
    await appController.safeRun(
      () => appController.updateProfile(profile, showLoading: true),
      title: '更新订阅',
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final isCurrent = ref.read(currentProfileIdProvider) == profile.id;
    final message = isCurrent
        ? '当前正在使用该订阅。删除后会自动切换到其他订阅；如果没有其他订阅，代理会停止。是否继续？'
        : '删除订阅后无法在本地恢复，是否继续？';
    final res = await globalState.showMessage(
      title: '删除订阅',
      message: TextSpan(text: message),
    );
    if (res != true) return;
    await appController.safeRun(
      () => appController.deleteProfile(profile.id),
      title: '删除订阅',
    );
    if (context.mounted) {
      Navigator.of(context).pop();
      context.showNotifier('订阅已删除');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(
      profilesProvider.select((profiles) => profiles.getProfile(profileId)),
    );
    if (profile == null) {
      return const BaseScaffold(
        title: '订阅详情',
        body: Center(child: Text('--')),
      );
    }
    return BaseScaffold(
      title: '订阅详情',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DetailsCard(
            children: [
              _DetailsLine(label: '名称', value: profile.realLabel),
              _DetailsLine(
                label: '类型',
                value: profile.type == ProfileType.url ? 'URL' : '文件',
              ),
              _DetailsLine(
                label: '更新时间',
                value: profile.lastUpdateDate?.lastUpdateTimeDesc ?? '--',
              ),
              if (profile.subscriptionInfo != null) ...[
                const SizedBox(height: 12),
                SubscriptionInfoView(
                  subscriptionInfo: profile.subscriptionInfo,
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          if (profile.type == ProfileType.url)
            FilledButton.icon(
              onPressed: () => _update(profile),
              icon: const Icon(Icons.sync_rounded),
              label: const Text('更新订阅'),
            ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _delete(context, ref, profile),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('删除订阅'),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Profile profile;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onDetails;
  final VoidCallback? onUpdate;

  const _ProfileCard({
    required this.profile,
    required this.selected,
    required this.onSelect,
    required this.onDetails,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? context.colorScheme.primaryContainer
          : context.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.cloud_queue_rounded,
                color: selected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.realLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.lastUpdateDate?.lastUpdateTimeDesc ?? '--',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (onUpdate != null)
                IconButton(
                  tooltip: '更新',
                  onPressed: onUpdate,
                  icon: const Icon(Icons.sync_rounded),
                ),
              IconButton(
                tooltip: '详情',
                onPressed: onDetails,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final List<Widget> children;

  const _DetailsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: children),
    );
  }
}

class _DetailsLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailsLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
