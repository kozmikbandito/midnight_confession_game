import 'alibi_model.dart'; // Mazeret modelini import ediyoruz.

// Bu sınıf, JSON dosyasındaki tek bir "characters" nesnesini temsil eder.
class CharacterModel {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final String roleInCase; // suspect, witness, visitor vb.
  final List<String> traits; // hırslı, sessiz vb.
  final String? motive;
  final AlibiModel alibi;
  final List<String> inventory;

  CharacterModel({
    required this.id,
    required this.name,
    required this.age,
    required this.occupation,
    required this.roleInCase,
    required this.traits,
    this.motive,
    required this.alibi,
    required this.inventory,
  });

  // Gelen JSON verisinden bir CharacterModel nesnesi oluşturur.
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    // 'traits' ve 'inventory' listelerini List<String>'e çeviriyoruz.
    final traitsList = (json['traits'] as List<dynamic>? ?? []).map((t) => t.toString()).toList();
    final inventoryList = (json['inventory'] as List<dynamic>? ?? []).map((i) => i.toString()).toList();

    return CharacterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'İsimsiz Şahıs',
      age: json['age'] ?? 0,
      occupation: json['occupation'] ?? 'Bilinmiyor',
      roleInCase: json['role_in_case'] ?? 'Bilinmiyor',
      traits: traitsList,
      motive: json['motive'],
      // 'alibi' nesnesini, AlibiModel.fromJson kullanarak kendi modelimize çeviriyoruz.
      alibi: AlibiModel.fromJson(json['alibi'] ?? {}),
      inventory: inventoryList,
    );
  }
}