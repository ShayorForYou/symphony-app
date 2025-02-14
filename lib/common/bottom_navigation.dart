import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../routes/app_router.dart';
import '../utils/widgets/dialog_widget.dart';
import 'assets_config.dart';

class MainWrapper extends StatefulWidget {
  final Widget child;

  const MainWrapper({super.key, required this.child});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _bottomNavIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
      switch (index) {
        case 0:
          context.go(GoRoutes.getWebRoute());
          break;
        case 1:
          context.go(GoRoutes.getHomeRoute());
          break;
        case 2:
          context.go(GoRoutes.getSocialsRoute());
          break;
        default:
      }
    });
  }

  bool _checkIndex() {
    if (_bottomNavIndex == 1) {
      return true;
    } else {
      setState(() {
        context.go(GoRoutes.getHomeRoute());
        _bottomNavIndex = 1;
      });
      return true;
    }
  }

  Widget _buildNavItem(String icon, String label, int index) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,

          onTap: () => _onItemTapped(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VectorGraphic(
                  loader: AssetBytesLoader(icon),
                  width: _bottomNavIndex == index ? 24 : 20,
                  height: _bottomNavIndex == index ? 24 : 20,
                  colorFilter: _bottomNavIndex == index
                      ? ColorFilter.mode(
                    Color(0xFFff002b),
                          BlendMode.srcIn,
                        )
                      : ColorFilter.mode(
                          Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                          BlendMode.srcIn,
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: _bottomNavIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: _bottomNavIndex == index
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, _) async {
        if (_bottomNavIndex == 1) {
          CustomDialog.show(
            context: context,
            title: 'Exit App',
            content: 'Are you sure you want to exit the app?',
            onCancel: () {
              context.pop();
            },
            onConfirm: () {
              SystemNavigator.pop();
            },
          );
        } else {
          _checkIndex();
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF181818)
                  : const Color(0xFFF5F5F5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Assets.svg.web, 'Website', 0),
                    _buildNavItem(Assets.svg.home, 'Home', 1),
                    _buildNavItem(Assets.svg.facebook, 'Social', 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
