
import 'package:flutter/material.dart';

import 'apply.dart';

void main() {
  runApp(MaterialApp(
    home: trackbus(),
  ));
}

class trackbus extends StatelessWidget {
  const trackbus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Buses'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Trackbusssss(), // Display the UserApply widget
    );
  }
}
