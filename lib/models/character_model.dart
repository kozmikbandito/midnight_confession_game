// Daha önce oluşturduğumuz InformationModel'i bu dosyada kullanacağımız
// için onu import ediyoruz.
import 'information_model.dart';

// Bu sınıf, JSON dosyasındaki tek bir "characters" nesnesini temsil eder.
class CharacterModel {
  final String id;
  final String name;
  final String basePrompt;
  final List<InformationModel> information; // Bir karakterin bildiği sırların listesi

  // Yapıcı metot (constructor)
  CharacterModel({
    required this.id,
    required this.name,
    required this.basePrompt,
    required this.information,
  });

  // JSON'dan gelen Map'i bir CharacterModel nesnesine dönüştürür.
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    // 'information' listesi JSON'da bir dizi olarak gelir.
    // Bu dizideki her bir elemanı bir InformationModel nesnesine çeviriyoruz.
    var infoFromJson = json['information'] as List? ?? [];
    List<InformationModel> infoList = infoFromJson.map((i) => InformationModel.fromJson(i)).toList();

    return CharacterModel(
      id: json['id'],
      name: json['name'],
      basePrompt: json['base_prompt'],
      information: infoList,
    );
  }
}