import 'package:flutter/material.dart';

class SurpriseView extends StatelessWidget {
  const SurpriseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Surprise')),
      body: const Center(child: Text('Surprise tab ready')),
    );
  }
}
