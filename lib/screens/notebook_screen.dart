import 'package:flutter/material.dart';
import '../engine/game_engine.dart';
import '../models/evidence_model.dart';
import '../models/information_model.dart';

class NotebookScreen extends StatelessWidget {
  final GameEngine gameEngine;

  const NotebookScreen({super.key, required this.gameEngine});

  @override
  Widget build(BuildContext context) {
    // GameState'ten bulunan kanıtları ve açığa çıkan sırları alıyoruz.
    final foundEvidence = gameEngine.gameState.getFoundEvidence();
    final unlockedInfo = gameEngine.gameState.getUnlockedInformation();

    // Sekmeli bir yapı için DefaultTabController kullanıyoruz.
    return DefaultTabController(
      length: 2, // İki sekmemiz var: Kanıtlar ve Bilgiler
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
            // 1. Sekme: Kanıtlar
            _buildEvidenceTab(foundEvidence),
            // 2. Sekme: Önemli Bilgiler (Sırlar)
            _buildInformationTab(unlockedInfo),
          ],
        ),
      ),
    );
  }

  // Kanıtlar sekmesini oluşturan widget.
  Widget _buildEvidenceTab(List<EvidenceModel> evidenceList) {
    if (evidenceList.isEmpty) {
      return const Center(child: Text('Henüz kanıt bulunamadı.'));
    }
    return ListView.builder(
      itemCount: evidenceList.length,
      itemBuilder: (context, index) {
        final evidence = evidenceList[index];
        return ListTile(
          leading: Icon(evidence.isRedHerring ? Icons.question_mark : Icons.check_circle_outline,
            color: evidence.isRedHerring ? Colors.orange : Colors.green
          ),
          title: Text(evidence.name),
          subtitle: Text(evidence.description),
        );
      },
    );
  }

  // Önemli Bilgiler (Sırlar) sekmesini oluşturan widget.
  Widget _buildInformationTab(List<InformationModel> infoList) {
    if (infoList.isEmpty) {
      return const Center(child: Text('Henüz önemli bir bilgi edinilmedi.'));
    }
    return ListView.builder(
      itemCount: infoList.length,
      itemBuilder: (context, index) {
        final info = infoList[index];
        return ListTile(
          leading: const Icon(Icons.key, color: Colors.amber),
          title: Text(info.description),
          subtitle: Text("Bu sır, bir konuşma sırasında açığa çıktı."),
        );
      },
    );
  }
}