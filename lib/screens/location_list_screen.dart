import 'package:flutter/material.dart';
import '../engine/game_engine.dart'; // GameEngine'i import ediyoruz
import '../models/location_model.dart';
import 'location_detail_screen.dart'; // Mekan detay ekranını import ediyoruz

class LocationListScreen extends StatelessWidget {
  // YENİ: Artık sadece mekan listesini değil, oyun motorunu da alıyoruz.
  final List<LocationModel> locations;
  final GameEngine gameEngine;

  const LocationListScreen({
    super.key,
    required this.locations,
    required this.gameEngine,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mekanlar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          // TODO: Mekanın kilidi açık mı diye kontrol et (is_unlocked). Kilitliyse farklı göster.
          final bool isLocked = !location.isUnlockedAtStart;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(isLocked ? Icons.lock_outline : Icons.location_on_outlined),
              ),
              title: Text(location.name),
              subtitle: Text(
                location.description ?? 'Açıklama yok.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: isLocked ? null : const Icon(Icons.arrow_forward_ios),
              // GÜNCELLEME: onTap fonksiyonunu dolduruyoruz.
              onTap: isLocked ? null : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LocationDetailScreen(
                      location: location,
                      gameEngine: gameEngine, // Oyun motorunu bir sonraki ekrana aktarıyoruz.
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