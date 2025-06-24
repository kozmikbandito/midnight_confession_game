// Bu sınıf, JSON dosyasındaki tek bir "rumors" nesnesini temsil eder.
class RumorModel {
  final String id;
  final String whoSaidIt;
  final String about;
  final String content;
  final String trustworthiness; // Güvenilirlik seviyesi (yüksek, orta, subjektif vb.)

  RumorModel({
    required this.id,
    required this.whoSaidIt,
    required this.about,
    required this.content,
    required this.trustworthiness,
  });

  // Gelen JSON verisinden bir RumorModel nesnesi oluşturur.
  factory RumorModel.fromJson(Map<String, dynamic> json) {
    return RumorModel(
      id: json['id'] ?? '',
      whoSaidIt: json['who_said_it'] ?? 'Bilinmiyor',
      about: json['about'] ?? 'Bilinmiyor',
      content: json['content'] ?? 'İçerik yok.',
      trustworthiness: json['trustworthiness'] ?? 'Bilinmiyor',
    );
  }
}