import '../models/case_model.dart';
import '../models/evidence_model.dart';
import '../models/information_model.dart';
import '../models/rumor_model.dart'; // Added import for RumorModel
import '../screens/dialogue_screen.dart'; 

class GameStateService {
  final CaseModel caseData;

  final Set<String> discoveredEvidenceIds = {};
  final Set<String> unlockedRoomIds = {};
  final Set<String> heardRumorIds = {};
  final Set<String> brokenAlibiCharacterIds = {};
  final Set<String> debunkedEvidenceIds = {};
  final Set<String> unlockedInformationIds = {};

  final Map<String, List<ChatMessage>> conversationHistories = {};

  GameStateService({required this.caseData}) {
    for (var room in caseData.rooms) {
      if (!room.locked) {
        unlockedRoomIds.add(room.id);
      }
    }
  }

  void addDiscoveredEvidence(String evidenceId) {
    discoveredEvidenceIds.add(evidenceId);
  }

  bool hasFoundEvidence(String evidenceId) {
    return discoveredEvidenceIds.contains(evidenceId);
  }

  void addMessageToHistory(String characterId, ChatMessage message) {
    if (!conversationHistories.containsKey(characterId)) {
      conversationHistories[characterId] = [];
    }
    conversationHistories[characterId]!.insert(0, message);
  }
  
  void unlockRoom(String roomId) {
    unlockedRoomIds.add(roomId);
  }

  void addUnlockedInfo(String infoId) {
    unlockedInformationIds.add(infoId);
  }
  
  // --- NOT DEFTERİ İÇİN YENİ FONKSİYONLAR ---

  List<EvidenceModel> getFoundEvidence() {
    return caseData.evidence
        .where((e) => discoveredEvidenceIds.contains(e.id))
        .toList();
  }

  // YENİ: getHeardRumors fonksiyonu eklendi
  List<RumorModel> getHeardRumors() {
     return caseData.rumors
        .where((r) => heardRumorIds.contains(r.id))
        .toList();
  }

  List<InformationModel> getUnlockedInformation() {
    List<InformationModel> unlockedList = [];
    // Bu fonksiyon, yeni JSON yapısına göre güncellenecek.
    // Şimdilik sırları karakterlerden değil, doğrudan case'den alıyoruz gibi varsayalım.
    // Gerçek oyunda bu mantık daha karmaşık olacak.
    // Örneğin, caseData.information gibi bir liste varsa:
    // if (caseData.information != null) {
    //   unlockedList = caseData.information!
    //       .where((info) => unlockedInformationIds.contains(info.id))
    //       .toList();
    // }
    return unlockedList;
  }
}