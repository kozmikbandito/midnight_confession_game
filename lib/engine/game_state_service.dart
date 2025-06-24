import '../models/case_model.dart';
import '../models/evidence_model.dart';
import '../models/information_model.dart';
import '../screens/dialogue_screen.dart'; // ChatMessage sınıfını kullanmak için

// Bu sınıf, tek bir oyun oturumunun tüm durumunu yönetir.
class GameStateService {
  // Yüklenen vakanın tüm verileri burada tutulur.
  final CaseModel caseData;

  // Oyuncunun ilerlemesini takip eden listeler.
  final Set<String> discoveredEvidenceIds = {};
  final Set<String> unlockedInformationIds = {};
  final Set<int> unlockedLocationIds = {};

  // Her karakterle yapılan konuşma geçmişini tutar.
  final Map<String, List<ChatMessage>> conversationHistories = {};

  GameStateService({required this.caseData}) {
    // Oyun başladığında, başlangıçta kilidi açık olan tüm mekanları listeye ekle.
    for (var location in caseData.locations) {
      if (location.isUnlockedAtStart) {
        unlockedLocationIds.add(location.id);
      }
    }
  }

  // --- Yardımcı Fonksiyonlar ---

  // Belirli bir kanıtın bulunup bulunmadığını kontrol eder.
  bool hasFoundEvidence(String evidenceId) {
    return discoveredEvidenceIds.contains(evidenceId);
  }

  // Yeni bir kanıt ekler.
  void addDiscoveredEvidence(String evidenceId) {
    discoveredEvidenceIds.add(evidenceId);
  }

  // Belirli bir sırrın açığa çıkıp çıkmadığını kontrol eder.
  bool hasUnlockedInfo(String infoId) {
    return unlockedInformationIds.contains(infoId);
  }
  
  // Yeni bir sırrı listeye ekler.
  void addUnlockedInfo(String infoId) {
    unlockedInformationIds.add(infoId);
  }
  
  // Bir konuşma geçmişine yeni bir mesaj ekler.
  void addMessageToHistory(String characterId, ChatMessage message) {
    if (!conversationHistories.containsKey(characterId)) {
      conversationHistories[characterId] = [];
    }
    // Konuşmayı güncel tutmak için mesajı başa ekliyoruz (reverse list gibi).
    conversationHistories[characterId]!.insert(0, message);
  }

  // --- NOT DEFTERİ İÇİN YENİ FONKSİYONLAR ---

  // Bulunan tüm kanıtların tam listesini döndürür.
  List<EvidenceModel> getFoundEvidence() {
    return caseData.evidence
        .where((e) => discoveredEvidenceIds.contains(e.id))
        .toList();
  }

  // Açığa çıkan tüm sırların tam listesini döndürür.
  List<InformationModel> getUnlockedInformation() {
    List<InformationModel> unlockedList = [];
    for (var character in caseData.characters) {
      unlockedList.addAll(character.information
          .where((info) => unlockedInformationIds.contains(info.id)));
    }
    return unlockedList;
  }
}