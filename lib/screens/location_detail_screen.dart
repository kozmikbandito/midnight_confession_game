import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../engine/game_engine.dart';

class LocationDetailScreen extends StatefulWidget {
  // GÜNCELLEME: Artık yeni RoomModel'i kullanıyoruz.
  final RoomModel room; // Changed from LocationModel to RoomModel
  final GameEngine gameEngine;

  const LocationDetailScreen({
    super.key,
    required this.room, // Changed from location to room
    required this.gameEngine,
  });

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  String _searchResult = '';
  bool _hasSearched = false;

  void _searchForClues() {
    // GÜNCELLEME: Artık yapay bir sonuç yerine, doğrudan oyun motorumuzdaki
    // searchLocation fonksiyonunu çağırıyoruz.
    final result = widget.gameEngine.searchLocation(widget.room.id);

    setState(() {
      _searchResult = result; // Motordan gelen sonucu ekranda gösteriyoruz.
      _hasSearched = true; // Arama yapıldığını işaretliyoruz.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mekan Betimlemesi (henüz JSON'da yok, ileride eklenebilir)
            Text(
              "Odaya giriyorsun. Etraf biraz dağınık görünüyor.", // Geçici metin
              style: TextStyle(fontSize: 18, color: Colors.grey.shade300, height: 1.5),
            ),
            const Spacer(), // Boşlukları doldurur

            // Arama Sonucu Alanı
            if (_hasSearched)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(77),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _searchResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),

            const SizedBox(height: 30),

            // Eylem Butonu
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Odayı Ara'),
              onPressed: _hasSearched ? null : _searchForClues, // Eğer daha önce arandıysa butonu pasif yap
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}