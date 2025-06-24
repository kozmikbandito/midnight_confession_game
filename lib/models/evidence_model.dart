// Bu sınıf, JSON dosyasındaki tek bir "evidence" nesnesini temsil eder.
class EvidenceModel {
  final String id;
  final String name;
  final String description;
  final int? locationId;      // Bir kanıtın mekanı olmayabilir, bu yüzden nullable (?)
  final bool isRedHerring;
  
  // Bu, bir kanıt nesnesi oluşturmak için kullandığımız yapıcı metottur (constructor).
  EvidenceModel({
    required this.id,
    required this.name,
    required this.description,
    this.locationId,
    required this.isRedHerring,
  });

  // Bu "factory constructor", JSON'dan gelen bir Map'i (yani bir anahtar-değer koleksiyonunu)
  // bizim anladığımız bir EvidenceModel nesnesine dönüştürür.
  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    return EvidenceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      locationId: json['location_id'],
      isRedHerring: json['is_red_herring'],
    );
  }
}