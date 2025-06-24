import 'package:flutter/material.dart';
import '../engine/game_engine.dart';
import 'dialogue_screen.dart';

class CharacterListScreen extends StatelessWidget {
  final GameEngine gameEngine;

  const CharacterListScreen({super.key, required this.gameEngine});

  @override
  Widget build(BuildContext context) {
    final characters = gameEngine.gameState.caseData.characters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şahıslar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(character.name[0]), // Karakterin isminin baş harfi
              ),
              title: Text(character.name),
              // GÜNCELLEME: Oyuncunun görmemesi gereken 'subtitle' kısmı kaldırıldı.
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DialogueScreen(gameEngine: gameEngine, character: character),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
