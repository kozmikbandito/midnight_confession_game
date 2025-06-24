// Bu sınıf, JSON dosyasındaki tek bir "relationships" nesnesini temsil eder.
// İki karakter arasındaki bağın doğasını tanımlar.
class RelationshipModel {
  final String source; // İlişkinin kaynağı (karakter id)
  final String target; // İlişkinin hedefi (karakter id)
  final String type;     // İlişki türü (öğrenci-eğitmen, dostluk, düşmanlık vb.)
  final String intensity; // İlişkinin yoğunluğu (yüksek, orta, zayıf vb.)
  final String? notes;   // Bu ilişkiyle ilgili tasarımcı notları

  RelationshipModel({
    required this.source,
    required this.target,
    required this.type,
    required this.intensity,
    this.notes,
  });

  // Gelen JSON verisinden bir RelationshipModel nesnesi oluşturur.
  factory RelationshipModel.fromJson(Map<String, dynamic> json) {
    return RelationshipModel(
      source: json['source'] ?? '',
      target: json['target'] ?? '',
      type: json['type'] ?? 'Bilinmiyor',
      intensity: json['intensity'] ?? 'Bilinmiyor',
      notes: json['notes'],
    );
  }
}