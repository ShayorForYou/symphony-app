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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Support')),
      body: Center(child: Text('Support')),
    );
  }
}
