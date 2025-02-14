import 'package:flutter/material.dart';

import '../dummy_data.dart';

class Social extends StatefulWidget {
  const Social({super.key});

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social',
        ),
      ),
      body: Center(
        child: Text(
          'Social',
        ),
      ),
    );
  }
}

