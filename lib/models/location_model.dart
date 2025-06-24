// Bu sınıf, JSON dosyasındaki tek bir "locations" nesnesini temsil eder.
class LocationModel {
  final int id;
  final String name;
  final String? description;
  final bool isUnlockedAtStart;

  // Yapıcı metot (constructor)
  LocationModel({
    required this.id,
    required this.name,
    this.description,
    required this.isUnlockedAtStart,
  });

  // JSON'dan gelen Map'i bir LocationModel nesnesine dönüştürür.
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isUnlockedAtStart: json['is_unlocked_at_start'],
    );
  }
}