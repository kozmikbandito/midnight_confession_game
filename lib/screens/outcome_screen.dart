// ===================================================================
// DOSYA: lib/screens/outcome_screen.dart
// ===================================================================
import 'package:flutter/material.dart';

class OutcomeScreen extends StatelessWidget {
  final bool wasSuccessful;
  final String culpritName;
  final String accusedName;

  const OutcomeScreen({super.key, required this.wasSuccessful, required this.culpritName, required this.accusedName});

  @override
  Widget build(BuildContext context) {
    final title = wasSuccessful ? 'VAKA KAPANDI' : 'VAKA BAŞARISIZ';
    final message = wasSuccessful
        ? 'Yaptığın titiz soruşturma sonucunda gerçek suçlu olan $culpritName\'ı adalete teslim ettin.'
        : '$accusedName\'nın masum olduğu kanıtlandı. Gerçek katil ise dışarıda, yeni bir av bekliyor...';
    final icon = wasSuccessful ? Icons.gavel_rounded : Icons.warning_amber_rounded;
    final color = wasSuccessful ? Colors.green.shade400 : Colors.red.shade400;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(icon, size: 120, color: color),
            const SizedBox(height: 30),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.grey.shade300, height: 1.5)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), backgroundColor: Colors.grey.shade700),
              child: const Text('Ana Menüye Dön', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}