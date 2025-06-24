import 'package:flutter/material.dart';
import '../engine/game_engine.dart';
import 'outcome_screen.dart';

class AccusationScreen extends StatefulWidget {
  final GameEngine gameEngine;

  const AccusationScreen({super.key, required this.gameEngine});

  @override
  State<AccusationScreen> createState() => _AccusationScreenState();
}

class _AccusationScreenState extends State<AccusationScreen> {
  String? _selectedCharacterId;

  void _makeAccusation() {
    if (_selectedCharacterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir şüpheli seçin.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final actualCulpritId = widget.gameEngine.gameState.caseData.culpritCharacterId;
    final wasSuccessful = _selectedCharacterId == actualCulpritId;

    final accusedName = widget.gameEngine.gameState.caseData.characters
        .firstWhere((c) => c.id == _selectedCharacterId)
        .name;
    final culpritName = widget.gameEngine.gameState.caseData.characters
        .firstWhere((c) => c.id == actualCulpritId)
        .name;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => OutcomeScreen(
          wasSuccessful: wasSuccessful,
          culpritName: culpritName,
          accusedName: accusedName,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final characters = widget.gameEngine.gameState.caseData.characters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yüzleşme'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Soruşturmanın sonuna geldin, dedektif.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Gerçek suçlu kim?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return Card(
                    color: _selectedCharacterId == character.id
                        ? Colors.teal.withAlpha(77) // DÜZELTME
                        : null,
                    child: RadioListTile<String>(
                      title: Text(character.name),
                      value: character.id,
                      groupValue: _selectedCharacterId,
                      onChanged: (value) {
                        setState(() {
                          _selectedCharacterId = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _makeAccusation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Suçlamayı Onayla'),
            ),
          ],
        ),
      ),
    );
  }
}