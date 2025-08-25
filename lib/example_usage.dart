import 'package:flutter/material.dart';
import 'widgets/actions/palm_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palm HR Button Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ButtonExampleScreen(),
    );
  }
}

class ButtonExampleScreen extends StatelessWidget {
  const ButtonExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palm HR Button Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Default button
              PalmButton(
                text: 'Back',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Back button pressed')),
                  );
                },
              ),
              const SizedBox(height: 20),
              
              // Full width button
              PalmButton(
                text: 'Submit',
                expandWidth: true,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Submit button pressed')),
                  );
                },
              ),
              const SizedBox(height: 20),
              
              // Disabled button
              const PalmButton(
                text: 'Disabled',
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 