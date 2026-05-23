import 'package:biankai_rocket/common/common.dart';
import 'package:biankai_rocket/controller.dart';
import 'package:biankai_rocket/enum/enum.dart';
import 'package:biankai_rocket/models/models.dart';
import 'package:biankai_rocket/providers/state.dart';
import 'package:biankai_rocket/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VpnManager extends ConsumerStatefulWidget {
  final Widget child;

  const VpnManager({super.key, required this.child});

  @override
  ConsumerState<VpnManager> createState() => _VpnContainerState();
}

class _VpnContainerState extends ConsumerState<VpnManager> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(vpnStateProvider, (prev, next) {
      if (prev != next) {
        showTip(next);
      }
    });
  }

  void showTip(VpnState state) {
    throttler.call(
      FunctionTag.vpnTip,
      () {
        if (!ref.read(isStartProvider) || state == globalState.lastVpnState) {
          return;
        }
        globalState.showNotifier(
          appLocalizations.vpnConfigChangeDetected,
          actionState: MessageActionState(
            actionText: appLocalizations.restart,
            action: () async {
              await globalState.handleStop();
              await appController.updateStatus(true);
            },
          ),
        );
      },
      duration: const Duration(seconds: 6),
      fire: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
