// Diğer tüm modellerimizi bu ana modelin içinde kullanacağımız için hepsini import ediyoruz.
import 'character_model.dart';
import 'evidence_model.dart';
import 'location_model.dart';

// Bu sınıf, tüm vaka dosyasını (JSON'ın en dış katmanını) temsil eder.
class CaseModel {
  final int id;
  final String title;
  final String brief;
  final String? culpritCharacterId; // Suçlunun ID'si, henüz atanmamış olabilir.
  final List<CharacterModel> characters;
  final List<EvidenceModel> evidence;
  final List<LocationModel> locations;

  // Yapıcı metot (constructor)
  CaseModel({
    required this.id,
    required this.title,
    required this.brief,
    this.culpritCharacterId,
    required this.characters,
    required this.evidence,
    required this.locations,
  });

  // JSON'dan gelen Map'i bir CaseModel nesnesine dönüştüren en kapsamlı factory metodu.
  factory CaseModel.fromJson(Map<String, dynamic> json) {
    // 'characters' listesini alıp her bir elemanı CharacterModel nesnesine çeviriyoruz.
    var charactersFromJson = json['characters'] as List? ?? [];
    List<CharacterModel> characterList = charactersFromJson.map((i) => CharacterModel.fromJson(i)).toList();

    // 'evidence' listesini alıp her bir elemanı EvidenceModel nesnesine çeviriyoruz.
    var evidenceFromJson = json['evidence'] as List? ?? [];
    List<EvidenceModel> evidenceList = evidenceFromJson.map((i) => EvidenceModel.fromJson(i)).toList();

    // 'locations' listesini alıp her bir elemanı LocationModel nesnesine çeviriyoruz.
    var locationsFromJson = json['locations'] as List? ?? [];
    List<LocationModel> locationList = locationsFromJson.map((i) => LocationModel.fromJson(i)).toList();

    return CaseModel(
      id: json['id'],
      title: json['title'],
      brief: json['brief'],
      culpritCharacterId: json['culprit_character_id'],
      characters: characterList,
      evidence: evidenceList,
      locations: locationList,
    );
  }
}