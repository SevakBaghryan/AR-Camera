import 'package:ar_cmera/ar_controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ARViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR View'),
      ),
      body: ARViewContainer(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter AR Integration'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ARController.startAR();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ARViewScreen(),
              ),
            );
          },
          child: Text('Launch AR'),
        ),
      ),
    );
  }
}

class ARViewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with the iOS AR view widget
    return Container(
      child: Text('Your iOS AR View Goes Here'),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
