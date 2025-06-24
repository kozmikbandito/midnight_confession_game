// Bu sınıf, JSON dosyasındaki "victim" nesnesini temsil eder.
class VictimModel {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final String causeOfDeath;
  final String deathTime;
  final String foundLocation;

  VictimModel({
    required this.id,
    required this.name,
    required this.age,
    required this.occupation,
    required this.causeOfDeath,
    required this.deathTime,
    required this.foundLocation,
  });

  // Gelen JSON verisinden bir VictimModel nesnesi oluşturur.
  factory VictimModel.fromJson(Map<String, dynamic> json) {
    return VictimModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Bilinmiyor',
      age: json['age'] ?? 0,
      occupation: json['occupation'] ?? 'Bilinmiyor',
      causeOfDeath: json['cause_of_death'] ?? 'Bilinmiyor',
      deathTime: json['death_time'] ?? 'Bilinmiyor',
      foundLocation: json['found_location'] ?? 'Bilinmiyor',
    );
  }
}