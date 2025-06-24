import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../engine/game_engine.dart'; 

class LocationDetailScreen extends StatefulWidget {
  final LocationModel location;
  final GameEngine gameEngine;

  const LocationDetailScreen({
    super.key,
    required this.location,
    required this.gameEngine,
  });

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  String _searchResult = '';
  bool _hasSearched = false;

  void _searchForClues() {
    final result = widget.gameEngine.searchLocation(widget.location.id);

    setState(() {
      _searchResult = result;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.location.description ?? 'Bu mekan hakkında bir açıklama yok.',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade300, height: 1.5),
            ),
            const Spacer(),
            if (_hasSearched)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(77), // DÜZELTME
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _searchResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('İpucu Ara'),
              onPressed: _hasSearched ? null : _searchForClues,
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