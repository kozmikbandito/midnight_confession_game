import 'package:flutter/material.dart';
import '../engine/game_engine.dart'; // GameEngine'i import ediyoruz
import 'dialogue_screen.dart';

class CharacterListScreen extends StatelessWidget {
  // YENİ: Artık karakter listesi yerine doğrudan oyun motorunu alıyoruz.
  final GameEngine gameEngine;

  const CharacterListScreen({super.key, required this.gameEngine});

  @override
  Widget build(BuildContext context) {
    // Karakter listesine oyun motorunun içindeki gameState üzerinden ulaşıyoruz.
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
                child: Text(character.name[0]),
              ),
              title: Text(character.name),
              // GÜNCELLEME: subtitle'ı, karakterin vaka içindeki rolünü gösterecek şekilde güncelliyoruz.
              subtitle: Text(character.occupation),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // YENİ: Diyalog ekranına da oyun motorunu ve seçilen karakteri aktarıyoruz.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DialogueScreen(
                      gameEngine: gameEngine,
                      character: character,
                    ),
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
