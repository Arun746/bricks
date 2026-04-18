import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench_and_bolts/core/enums/enums.dart';
import 'package:wrench_and_bolts/core/utils/functions.dart';
import 'package:wrench_and_bolts/core/widgets/scaffold_body/scaffold_body_provider.dart';

class ScaffoldBody extends ConsumerStatefulWidget {
  final Widget child;

  const ScaffoldBody({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScaffoldBodyState();
}

class _ScaffoldBodyState extends ConsumerState<ScaffoldBody> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(scaffoldBodyProvider);

    // Listen for connection lost message and show snackbar
    ref.listen(scaffoldBodyProvider, (previous, current) {
      if (current.shouldShowConnectionLostMessage &&
          (previous?.shouldShowConnectionLostMessage != true)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSnackbar(
            context: context,
            message: 'Connection lost. Please check your internet connection.',
            type: SnackbarType.error,
          );
          // Clear the message flag after showing snackbar
          ref.read(scaffoldBodyProvider.notifier).clearConnectionLostMessage();
        });
      }
    });

    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation if loading with preventBack flag is enabled
        if (provider.preventBack && provider.isLoading) {
          return false;
        }
        ref.read(scaffoldBodyProvider.notifier).disableLoading();
        if (Navigator.of(context).canPop()) {
          return true;
        }

        return false;
      },
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.child,
                if (provider.isLoading)
                  Positioned.fill(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                          child: provider.loading,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
