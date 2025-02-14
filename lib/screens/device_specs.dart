import 'package:flutter/material.dart';

class DeviceSpecification extends StatefulWidget {
  const DeviceSpecification({super.key});

  @override
  State<DeviceSpecification> createState() => _DeviceSpecificationState();
}

class _DeviceSpecificationState extends State<DeviceSpecification> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Device Specification',
        ),
      ),
      body: Center(
        child: Text(
          'Device Specification',
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

