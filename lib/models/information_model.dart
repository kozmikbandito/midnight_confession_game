// Bu dosya, bir sırrı, onu tetikleyen şeyi ve tetikleyicinin detaylarını
// temsil eden üç farklı sınıf içerir.

// --- 3. Sınıf: Tetikleyici Kanıt ---
// Bu en küçük sınıf, bir tetikleyicinin hangi kanıta ait olduğunu
// ve o kanıtın adını tutar. JSON'daki iç içe yapıyı temsil eder.
class TriggerEvidenceModel {
  final String id;
  final String name;

  TriggerEvidenceModel({required this.id, required this.name});

  factory TriggerEvidenceModel.fromJson(Map<String, dynamic> json) {
    return TriggerEvidenceModel(
      id: json['id'],
      name: json['name'],
    );
  }
}


// --- 2. Sınıf: Tetikleyici ---
// Bir sırrı neyin tetiklediğini tanımlar. Şu an için sadece kanıtları
// destekliyor ama ileride başka şeyler de ekleyebiliriz.
class TriggerModel {
  final int id;
  final TriggerEvidenceModel? evidence; // Tetikleyici bir kanıt olabilir.

  TriggerModel({required this.id, this.evidence});

  factory TriggerModel.fromJson(Map<String, dynamic> json) {
    return TriggerModel(
      id: json['id'],
      // JSON içinde 'evidence' alanı varsa, onu bir TriggerEvidenceModel nesnesine çevirir.
      evidence: json['evidence'] != null
          ? TriggerEvidenceModel.fromJson(json['evidence'])
          : null,
    );
  }
}


// --- 1. Ana Sınıf: Bilgi / Sır ---
// Bir karakterin sakladığı bir sırrı temsil eden ana modeldir.
class InformationModel {
  final String id;
  final String description; // Bu, tasarımcı için bir nottur.
  final String lockedPrompt;
  final String unlockedPrompt;
  final int? unlocksLocationId; // Bu sır bir mekanın kilidini açıyor mu?
  final List<TriggerModel> triggers; // Bu sırrı hangi tetikleyiciler açar?

  InformationModel({
    required this.id,
    required this.description,
    required this.lockedPrompt,
    required this.unlockedPrompt,
    this.unlocksLocationId,
    required this.triggers,
  });

  factory InformationModel.fromJson(Map<String, dynamic> json) {
    // 'triggers' listesi JSON'da bir dizi olarak gelir.
    // Bu dizideki her bir elemanı bir TriggerModel nesnesine çeviriyoruz.
    var triggersFromJson = json['triggers'] as List? ?? [];
    List<TriggerModel> triggerList = triggersFromJson.map((i) => TriggerModel.fromJson(i)).toList();

    return InformationModel(
      id: json['id'],
      description: json['description'] ?? '',
      lockedPrompt: json['locked_prompt'] ?? '',
      unlockedPrompt: json['unlocked_prompt'] ?? '',
      unlocksLocationId: json['unlocks_location_id'],
      triggers: triggerList,
    );
  }
}