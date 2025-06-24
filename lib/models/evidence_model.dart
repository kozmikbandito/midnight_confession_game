// Bu dosya, bir kanıtı ve o kanıtın kiminle ilgili olduğunu
// tanımlayan iki sınıf içerir.

// --- Yardımcı Sınıf: İlgili Kişi ---
// Bir kanıtın hangi karakterle, ne tür bir ilişkisi olduğunu tutar.
class RelatedToModel {
  final String characterId;
  final String relationType; // mülkiyet, kurban, şüpheli vb.
  final String relevance;    // alaka düzeyi (yüksek, orta, zayıf)

  RelatedToModel({
    required this.characterId,
    required this.relationType,
    required this.relevance,
  });

  factory RelatedToModel.fromJson(Map<String, dynamic> json) {
    return RelatedToModel(
      characterId: json['character_id'] ?? '',
      relationType: json['relation_type'] ?? 'Bilinmiyor',
      relevance: json['relevance'] ?? 'Bilinmiyor',
    );
  }
}

// --- Ana Sınıf: Kanıt ---
// JSON dosyasındaki tek bir "evidence" nesnesini temsil eder.
class EvidenceModel {
  final String id;
  final String name;
  final String? location; // Kanıtın bulunduğu yerin ID'si
  final String description;
  final String type; // fiziksel, belge vb.
  final bool isHidden; // Kanıt başlangıçta gizli mi?
  final String validity; // geçerlilik (valid, misleading)
  final List<RelatedToModel> relatedTo; // Kanıtın ilgili olduğu kişilerin listesi

  EvidenceModel({
    required this.id,
    required this.name,
    this.location,
    required this.description,
    required this.type,
    required this.isHidden,
    required this.validity,
    required this.relatedTo,
  });

  // Gelen JSON verisinden bir EvidenceModel nesnesi oluşturur.
  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    // 'related_to' alanı bir liste olduğu için onu List<RelatedToModel>'e çeviriyoruz.
    final relations = json['related_to'] as List<dynamic>? ?? [];
    final List<RelatedToModel> relationsList = relations.map((r) => RelatedToModel.fromJson(r)).toList();

    return EvidenceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'İsimsiz Kanıt',
      location: json['location'],
      description: json['description'] ?? 'Açıklama yok.',
      type: json['type'] ?? 'Bilinmiyor',
      isHidden: json['is_hidden'] ?? false,
      validity: json['validity'] ?? 'valid',
      relatedTo: relationsList,
    );
  }
}