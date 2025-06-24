// ===================================================================
// DOSYA: lib/screens/notebook_screen.dart
// ===================================================================
import 'package:flutter/material.dart';
import '../engine/game_engine.dart';
import '../models/evidence_model.dart';
import '../models/information_model.dart';

class NotebookScreen extends StatelessWidget {
  final GameEngine gameEngine;

  const NotebookScreen({super.key, required this.gameEngine});

  @override
  Widget build(BuildContext context) {
    final foundEvidence = gameEngine.gameState.getFoundEvidence();
    // getUnlockedInformation fonksiyonu henüz tam dolu değil, ileride doldurulacak.
    // final unlockedInfo = gameEngine.gameState.getUnlockedInformation();
    final unlockedInfo = <InformationModel>[]; // Şimdilik boş liste

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Not Defteri'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.description_outlined), text: 'Kanıtlar'),
              Tab(icon: Icon(Icons.lightbulb_outline), text: 'Önemli Bilgiler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEvidenceTab(foundEvidence),
            _buildInformationTab(unlockedInfo),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceTab(List<EvidenceModel> evidenceList) {
    if (evidenceList.isEmpty) {
      return const Center(child: Text('Henüz kanıt bulunamadı.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: evidenceList.length,
      itemBuilder: (context, index) {
        final evidence = evidenceList[index];
        final isMisleading = evidence.validity == 'misleading';
        return Card(
          child: ListTile(
            leading: Icon(
              isMisleading ? Icons.question_mark : Icons.check_circle_outline,
              color: isMisleading ? Colors.orange : Colors.green,
            ),
            title: Text(evidence.name),
            subtitle: Text(evidence.description),
          ),
        );
      },
    );
  }

  Widget _buildInformationTab(List<InformationModel> infoList) {
    if (infoList.isEmpty) {
      return const Center(child: Text('Henüz önemli bir bilgi edinilmedi.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: infoList.length,
      itemBuilder: (context, index) {
        final info = infoList[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.key, color: Colors.amber),
            title: Text(info.description),
            subtitle: const Text("Bu sır, bir konuşma sırasında açığa çıktı."),
          ),
        );
      },
    );
  }
}