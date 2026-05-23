// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:biankai_rocket/common/common.dart';
import 'package:biankai_rocket/enum/enum.dart';
import 'package:biankai_rocket/models/models.dart';
import 'package:flutter/material.dart';

const appName = '卞恺rocket';
const appHelperService = 'BiankaiRocketHelperService';
const coreName = 'clash.meta';
const browserUa =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
const packageName = 'com.biankai.rocket';
final unixSocketPath =
    '/tmp/BiankaiRocketSocket_${Random().nextInt(10000)}.sock';
const helperPort = 47890;
const maxTextScale = 1.4;
const minTextScale = 0.8;
final baseInfoEdgeInsets = EdgeInsets.symmetric(
  vertical: 16.mAp,
  horizontal: 16.mAp,
);
final listHeaderPadding = EdgeInsets.only(
  left: 16.mAp,
  right: 8.mAp,
  top: 24.mAp,
  bottom: 8.mAp,
);

const watchExecution = true;

final defaultTextScaleFactor =
    WidgetsBinding.instance.platformDispatcher.textScaleFactor;
const httpTimeoutDuration = Duration(milliseconds: 5000);
const moreDuration = Duration(milliseconds: 100);
const animateDuration = Duration(milliseconds: 100);
const midDuration = Duration(milliseconds: 200);
const commonDuration = Duration(milliseconds: 300);
const defaultUpdateDuration = Duration(days: 1);
const MMDB = 'GEOIP.metadb';
const ASN = 'ASN.mmdb';
const GEOIP = 'GEOIP.dat';
const GEOSITE = 'GEOSITE.dat';
final double kHeaderHeight = system.isDesktop
    ? !system.isMacOS
          ? 40
          : 28
    : 0;
const profilesDirectoryName = 'profiles';
const localhost = '127.0.0.1';
const clashConfigKey = 'clash_config';
const configKey = 'config';
const double dialogCommonWidth = 300;
const repository = 'kairkiss/biankai-rocket';
const expertModePasswordHash =
    '14bb7d51f04df9c4d1c6a4e61eff54b33b6954ed553c2b2e9d2a01fa8ff6c8d7';
const defaultExternalController = '127.0.0.1:9090';
const maxMobileWidth = 600;
const maxLaptopWidth = 840;
const defaultTestUrl = 'https://www.gstatic.com/generate_204';
final commonFilter = ImageFilter.blur(
  sigmaX: 5,
  sigmaY: 5,
  tileMode: TileMode.mirror,
);

const listEquality = ListEquality();
const navigationItemListEquality = ListEquality<NavigationItem>();
const trackerInfoListEquality = ListEquality<TrackerInfo>();
const stringListEquality = ListEquality<String>();
const intListEquality = ListEquality<int>();
const logListEquality = ListEquality<Log>();
const groupListEquality = ListEquality<Group>();
const ruleListEquality = ListEquality<Rule>();
const scriptListEquality = ListEquality<Script>();
const externalProviderListEquality = ListEquality<ExternalProvider>();
const packageListEquality = ListEquality<Package>();
const profileListEquality = ListEquality<Profile>();
const hotKeyActionListEquality = ListEquality<HotKeyAction>();
const stringAndStringMapEquality = MapEquality<String, String>();
const stringAndStringMapEntryListEquality =
    ListEquality<MapEntry<String, String>>();
const stringAndStringMapEntryIterableEquality =
    IterableEquality<MapEntry<String, String>>();
const stringAndObjectMapEntryIterableEquality =
    IterableEquality<MapEntry<String, Object?>>();
const delayMapEquality = MapEquality<String, Map<String, int?>>();
const stringSetEquality = SetEquality<String>();
const keyboardModifierListEquality = SetEquality<KeyboardModifier>();

const viewModeColumnsMap = {
  ViewMode.mobile: [2, 1],
  ViewMode.laptop: [3, 2],
  ViewMode.desktop: [4, 3],
};

const proxiesListStoreKey = PageStorageKey<String>('proxies_list');
const toolsStoreKey = PageStorageKey<String>('tools');
const profilesStoreKey = PageStorageKey<String>('profiles');

const defaultPrimaryColor = 0xFF007AFF;

double getWidgetHeight(num lines) {
  final space = 14.mAp;
  return max(lines * (80.ap + space) - space, 0);
}

const maxLength = 1000;

final mainIsolate = 'BiankaiRocketMainIsolate';

final serviceIsolate = 'BiankaiRocketServiceIsolate';

const defaultPrimaryColors = [
  defaultPrimaryColor,
  0xFF34C759,
  0xFFFF9500,
  0xFFFF3B30,
  0xFF8E8E93,
  defaultPrimaryColor,
  0xFF5856D6,
];

const scriptTemplate = '''
const main = (config) => {
  return config;
}''';

const backupDatabaseName = 'database.sqlite';
const configJsonName = 'config.json';
