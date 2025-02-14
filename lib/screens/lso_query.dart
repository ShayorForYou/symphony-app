import 'package:flutter/material.dart';

class LsoQuery extends StatefulWidget {
  const LsoQuery({super.key});

  @override
  State<LsoQuery> createState() => _LsoQueryState();
}

class _LsoQueryState extends State<LsoQuery> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lso Query')),
      body: Center(child: Text('Lso Query')),
    );
  }
}
