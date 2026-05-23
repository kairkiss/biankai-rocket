import 'package:biankai_rocket/enum/enum.dart';
import 'package:biankai_rocket/models/models.dart';
import 'package:biankai_rocket/views/views.dart';
import 'package:flutter/material.dart';

class Navigation {
  static Navigation? _instance;

  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
    bool expertMode = false,
  }) {
    final dashboardItem = NavigationItem(
      keep: false,
      icon: Icon(Icons.home_outlined),
      label: PageLabel.dashboard,
      builder: (_) =>
          const DashboardView(key: GlobalObjectKey(PageLabel.dashboard)),
    );
    if (!expertMode) {
      return [dashboardItem];
    }
    return [
      dashboardItem,
      NavigationItem(
        icon: const Icon(Icons.swap_vert_circle_outlined),
        label: PageLabel.proxies,
        builder: (_) =>
            const ProxiesView(key: GlobalObjectKey(PageLabel.proxies)),
        modes: hasProxies
            ? [NavigationItemMode.mobile, NavigationItemMode.desktop]
            : [],
      ),
      NavigationItem(
        icon: Icon(Icons.list_alt_outlined),
        label: PageLabel.profiles,
        builder: (_) =>
            const ProfilesView(key: GlobalObjectKey(PageLabel.profiles)),
      ),
      NavigationItem(
        icon: Icon(Icons.view_timeline),
        label: PageLabel.requests,
        builder: (_) =>
            const RequestsView(key: GlobalObjectKey(PageLabel.requests)),
        description: 'requestsDesc',
        modes: [NavigationItemMode.desktop, NavigationItemMode.more],
      ),
      NavigationItem(
        icon: Icon(Icons.ballot),
        label: PageLabel.connections,
        builder: (_) =>
            const ConnectionsView(key: GlobalObjectKey(PageLabel.connections)),
        description: 'connectionsDesc',
        modes: [NavigationItemMode.desktop, NavigationItemMode.more],
      ),
      NavigationItem(
        icon: Icon(Icons.storage),
        label: PageLabel.resources,
        description: 'resourcesDesc',
        builder: (_) =>
            const ResourcesView(key: GlobalObjectKey(PageLabel.resources)),
        modes: [NavigationItemMode.more],
      ),
      NavigationItem(
        icon: const Icon(Icons.subject_outlined),
        label: PageLabel.logs,
        builder: (_) => const LogsView(key: GlobalObjectKey(PageLabel.logs)),
        description: 'logsDesc',
        modes: openLogs
            ? [
                NavigationItemMode.desktop,
                NavigationItemMode.mobile,
                NavigationItemMode.more,
              ]
            : [NavigationItemMode.more],
      ),
      NavigationItem(
        icon: Icon(Icons.settings_outlined),
        label: PageLabel.tools,
        builder: (_) => const ToolsView(key: GlobalObjectKey(PageLabel.tools)),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
    ];
  }

  Navigation._internal();

  factory Navigation() {
    _instance ??= Navigation._internal();
    return _instance!;
  }
}

final navigation = Navigation();
