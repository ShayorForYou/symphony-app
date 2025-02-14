import 'package:app/routes/app_router.dart';
import 'package:app/utils/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_indicator/loading_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return GlobalLoaderOverlay(
      overlayColor: Colors.black.withValues(alpha: 0.5),
      useBackButtonInterceptor: true,
      overlayWidgetBuilder: (_) {
        return Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const LoadingIndicator(
              indicatorType: Indicator.ballClipRotateMultiple,
            ),
          ),
        );
      },
      child: MaterialApp.router(
        title: 'Symphony',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode:
            brightness == Brightness.light ?
            ThemeMode.light
            : ThemeMode.dark,
        routerConfig: router,
      ),
    );
  }
}
