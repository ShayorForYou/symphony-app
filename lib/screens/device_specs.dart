import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../common/assets_config.dart';

class DeviceSpecification extends StatefulWidget {
  const DeviceSpecification({super.key});

  @override
  State<DeviceSpecification> createState() => _DeviceSpecificationState();
}

class _DeviceSpecificationState extends State<DeviceSpecification> {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo? androidInfo;
  List<String> availableSensors = [];

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    androidInfo = await deviceInfo.androidInfo;
    _checkAvailableSensors();
  }

  Future<void> _checkAvailableSensors() async {
    final sensors = <String>[];

    try {
      accelerometerEventStream()
          .first
          .timeout(const Duration(milliseconds: 500));
      sensors.add('Accelerometer');
    } catch (_) {}

    try {
      gyroscopeEventStream().first.timeout(const Duration(milliseconds: 500));
      sensors.add('Gyroscope');
    } catch (_) {}

    try {
      magnetometerEventStream()
          .first
          .timeout(const Duration(milliseconds: 500));
      sensors.add('Magnetometer');
    } catch (_) {}

    if (androidInfo != null) {
      if (androidInfo!.fingerprint.isNotEmpty) {
        sensors.add('Fingerprint');
      }
    }

    setState(() {
      availableSensors = sensors;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (androidInfo == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotateMultiple,
              colors: [Theme.of(context).colorScheme.primary],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Device Specification'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemCount: 1,
          itemBuilder: (context, _) => Column(
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 100),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF181818)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19000000), // Precalculated alpha
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Powered by',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Android™ ${androidInfo!.version.release}',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        FontAwesomeIcons.android,
                        color: Colors.green,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SpecificationCard(
                      icon: Assets.svg.processor,
                      title: 'Processor',
                      value: androidInfo!.hardware,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SpecificationCard(
                      icon: Assets.svg.storage,
                      title: 'Storage',
                      value:
                      '${androidInfo!.supported64BitAbis.isNotEmpty ? "128" : "64"} GB',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: SpecificationCard(
                  icon: Assets.svg.display,
                  title: 'Display',
                  value:
                  '64MP + 2 MP Macro Rear & 32MP Super Selfie with Display Flash',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SpecificationCard(
                      icon: Assets.svg.rom,
                      title: 'RAM',
                      value:
                      '${androidInfo!.supported64BitAbis.isNotEmpty ? "8" : "4"} GB',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SpecificationCard(
                      icon: Assets.svg.sim,
                      title: 'SIM',
                      value: androidInfo!.isPhysicalDevice
                          ? 'Dual SIM'
                          : 'Single SIM',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SpecificationCard(
                      icon: Assets.svg.network,
                      title: 'Network',
                      value: '4G, 5G, 2G',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SpecificationCard(
                      icon: Assets.svg.battery,
                      title: 'Battery',
                      value: '5000mAh',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: SpecificationCard(
                  icon: Assets.svg.fingerprint,
                  title: 'Device Sensors',
                  value: availableSensors.isEmpty
                      ? 'Checking sensors...'
                      : availableSensors.join(', '),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SpecificationCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  static final Map<String, BytesLoader> _cachedSvgs = {};

  const SpecificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  BytesLoader _getCachedLoader(String icon) {
    return _cachedSvgs.putIfAbsent(icon, () => AssetBytesLoader(icon));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF181818)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000), // Precalculated alpha
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: VectorGraphic(
                loader: _getCachedLoader(icon),
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
