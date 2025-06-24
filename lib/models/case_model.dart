// Diğer tüm modellerimizi bu ana modelin içinde kullanacağımız için hepsini import ediyoruz.
import 'victim_model.dart';
import 'character_model.dart';
import 'relationship_model.dart';
import 'room_model.dart';
import 'evidence_model.dart';
import 'rumor_model.dart';

// Bu sınıf, tüm vaka dosyasını (JSON'ın en dış katmanını) temsil eder.
class CaseModel {
  final String id;
  final String title;
  final String description;
  final VictimModel victim;
  final List<CharacterModel> characters;
  final List<RelationshipModel> relationships;
  final List<RoomModel> rooms;
  final List<EvidenceModel> evidence;
  final List<RumorModel> rumors;

  CaseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.victim,
    required this.characters,
    required this.relationships,
    required this.rooms,
    required this.evidence,
    required this.rumors,
  });

  // Gelen JSON verisinden bir CaseModel nesnesi oluşturur.
  factory CaseModel.fromJson(Map<String, dynamic> json) {
    // JSON'daki en dış 'case' anahtarının altındaki veriyi alıyoruz.
    final caseData = json['case'] ?? {};

    // Her bir listeyi, ilgili modelin fromJson metodunu kullanarak
    // nesne listelerine dönüştürüyoruz.
    final charactersList = (caseData['characters'] as List<dynamic>? ?? [])
        .map((c) => CharacterModel.fromJson(c))
        .toList();
    
    final relationshipsList = (caseData['relationships'] as List<dynamic>? ?? [])
        .map((r) => RelationshipModel.fromJson(r))
        .toList();

    final roomsList = (caseData['rooms'] as List<dynamic>? ?? [])
        .map((r) => RoomModel.fromJson(r))
        .toList();
        
    final evidenceList = (caseData['evidence'] as List<dynamic>? ?? [])
        .map((e) => EvidenceModel.fromJson(e))
        .toList();

    final rumorsList = (caseData['rumors'] as List<dynamic>? ?? [])
        .map((r) => RumorModel.fromJson(r))
        .toList();

    return CaseModel(
      id: caseData['id'] ?? '',
      title: caseData['title'] ?? 'İsimsiz Vaka',
      description: caseData['description'] ?? 'Açıklama yok.',
      victim: VictimModel.fromJson(caseData['victim'] ?? {}),
      characters: charactersList,
      relationships: relationshipsList,
      rooms: roomsList,
      evidence: evidenceList,
      rumors: rumorsList,
    );
  }
}