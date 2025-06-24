// ===================================================================
// DOSYA: lib/screens/location_list_screen.dart
// ===================================================================
import 'package:flutter/material.dart';
import '../engine/game_engine.dart';
import '../models/room_model.dart';
import 'location_detail_screen.dart';

class LocationListScreen extends StatelessWidget {
  final GameEngine gameEngine;
  const LocationListScreen({super.key, required this.gameEngine});

  @override
  Widget build(BuildContext context) {
    final List<RoomModel> allRooms = gameEngine.gameState.caseData.rooms;
    final Set<String> unlockedRoomIds = gameEngine.gameState.unlockedRoomIds;
    return Scaffold(
      appBar: AppBar(title: const Text('Mekanlar'), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.builder(
        itemCount: allRooms.length,
        itemBuilder: (context, index) {
          final room = allRooms[index];
          final bool isLocked = !unlockedRoomIds.contains(room.id);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: Icon(isLocked ? Icons.lock_outline : Icons.location_on_outlined)),
              title: Text(room.name),
              trailing: isLocked ? null : const Icon(Icons.arrow_forward_ios),
              onTap: isLocked ? null : () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationDetailScreen(room: room, gameEngine: gameEngine))),
            ),
          );
        },
      ),
    );
  }
}