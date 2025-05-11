import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/presentation/providers/current_data.dart';
import 'package:stirred_backoffice/presentation/router.dart';
import 'dart:async';

import 'package:stirred_backoffice/presentation/views/splash_view.dart';
import 'package:stirred_backoffice/presentation/widgets/error_placeholder.dart';

class RootView extends ConsumerWidget {
  const RootView({super.key});


  Future<void> _dispatch(CurrentDataNotifierState state) async {
    state.map(
      authentified: (state) {
        router.go(HomeRoute.route(HomeTabConstants.defaultTabIndex));
      },
      unauthentified: (state) {
        router.go(LoginRoute.route);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(currentDataNotifierProvider);

    return notifier.when(
      loading: () => const SplashView(),
      error: (error, stacktrace) => ErrorPlaceholder(
        message: error.toString(),
        stackTrace: stacktrace,
      ),
      data: (state) {
        Timer(const Duration(seconds: 2), () => _dispatch(state));
        return const SplashView();
      },
    );
  }
}
