import 'package:biankai_rocket/common/app_localizations.dart';
import 'package:biankai_rocket/views/config/general.dart';
import 'package:biankai_rocket/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ConfigView extends StatelessWidget {
  const ConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: appLocalizations.basicConfig,
      body: generateListView(generalItems),
    );
  }
}
