import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vector_graphics/vector_graphics.dart';
import '../common/assets_config.dart';
import '../routes/app_router.dart';
import 'device_specs.dart';
import 'service_center.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  void _navigateToScreen(BuildContext context, String screenName) {
    switch (screenName) {
      case 'Hotline':
        break;
      case 'Service Center':
        context.push(GoRoutes.getServiceCenterRoute());
        break;
      case 'LSO Query':
        context.push(GoRoutes.getLsoQueryRoute());

        break;
      case 'Feedback':
        break;
      case 'Specification':
        context.push(GoRoutes.getDeviceSpecificationRoute());

        break;
      case 'Book An Appointment':
        break;
    }
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final Size screenSize = MediaQuery.of(context).size;

    final double iconSize = screenSize.shortestSide * 0.08;
    final double fontSize = screenSize.shortestSide * 0.032;
    final double containerPadding = screenSize.shortestSide * 0.03;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF181818)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(screenSize.shortestSide * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(containerPadding),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(screenSize.shortestSide * 0.03),
                ),
                child: VectorGraphic(
                  loader: AssetBytesLoader(icon),
                  width: 40,
                  height: 40,
                )),
            SizedBox(height: screenSize.shortestSide * 0.02),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double gridPadding = screenSize.shortestSide * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: EdgeInsets.all(gridPadding),
            child: GridView.count(
              crossAxisCount: isLandscape ? 3 : 2,
              mainAxisSpacing: gridPadding,
              crossAxisSpacing: gridPadding,
              childAspectRatio: isLandscape ? 1.5 : 1.0,
              children: [
                _buildMenuItem(
                  context: context,
                  icon: Assets.svg.hotline,
                  title: 'Hotline',
                  onTap: () => _navigateToScreen(context, 'Hotline'),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Assets.svg.service,
                  title: 'Service Center',
                  onTap: () => _navigateToScreen(context, 'Service Center'),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Assets.svg.lso,
                  title: 'LSO Query',
                  onTap: () => _navigateToScreen(context, 'LSO Query'),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Assets.svg.feedback,
                  title: 'Feedback',
                  onTap: () => _navigateToScreen(context, 'Feedback'),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Assets.svg.specification,
                  title: 'Specification',
                  onTap: () => _navigateToScreen(context, 'Specification'),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Assets.svg.appointment,
                  title: 'Book An\nAppointment',
                  onTap: () =>
                      _navigateToScreen(context, 'Book An Appointment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
