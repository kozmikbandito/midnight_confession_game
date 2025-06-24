import 'package:flutter/material.dart';
import '../models/case_model.dart';
import 'character_list_screen.dart'; 
import 'location_list_screen.dart'; 
import 'notebook_screen.dart';
import 'accusation_screen.dart';
import '../engine/game_state_service.dart';
import '../engine/game_engine.dart';
import '../services/profile_service.dart';
import 'profile_creation_screen.dart';

class InvestigationScreen extends StatefulWidget {
  final CaseModel caseData;
  const InvestigationScreen({super.key, required this.caseData});

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  late GameStateService _gameState;
  late GameEngine _gameEngine;
  
  final ProfileService _profileService = ProfileService();
  DetectiveProfile? _detectiveProfile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _gameState = GameStateService(caseData: widget.caseData);
    _gameEngine = GameEngine(gameState: _gameState);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.loadProfile();
    setState(() {
      _detectiveProfile = profile;
      _isLoadingProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final detectiveName = _detectiveProfile?.name ?? "Bilinmeyen Dedektif";
    final detectiveAvatar = _detectiveProfile?.gender == Gender.male
        ? Icons.person_outline
        : Icons.person_outline_sharp;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.caseData.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(detectiveAvatar, size: 100, color: Colors.teal.shade200),
                    const SizedBox(height: 10),
                    Text(
                      detectiveName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                     Text(
                      "Soruşturma devam ediyor...",
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black26, // DÜZELTME
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildActionButton(
                      context, 
                      icon: Icons.people_outline, 
                      label: 'Şahıslar', 
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CharacterListScreen(
                              gameEngine: _gameEngine,
                            ),
                          ),
                        );
                      }
                    ),
                    _buildActionButton(
                      context, 
                      icon: Icons.map_outlined, 
                      label: 'Mekanlar', 
                      onTap: () {
                         Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LocationListScreen(
                              locations: widget.caseData.locations,
                              gameEngine: _gameEngine,
                            ),
                          ),
                        );
                      }
                    ),
                    _buildActionButton(
                      context, 
                      icon: Icons.book_outlined, 
                      label: 'Not Defteri', 
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotebookScreen(
                              gameEngine: _gameEngine,
                            ),
                          ),
                        );
                      }
                    ),
                    _buildActionButton(
                      context, 
                      icon: Icons.phone_in_talk_outlined, 
                      label: 'Vakayı Kapat', 
                      color: Colors.red.shade400, 
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AccusationScreen(
                              gameEngine: _gameEngine,
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap, Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: color ?? Theme.of(context).cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}