import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/case_model.dart'; // Artık yeni ve kapsamlı ana modelimizi import ediyoruz.

// Bu sınıf, vaka dosyalarını yüklemek ve parse etmekten sorumludur.
class CaseLoaderService {

  // Belirtilen dosya yolundan bir vaka yükler.
  Future<CaseModel> loadCase(String casePath) async {
    try {
      // 1. Projenin asset'lerinden JSON dosyasını metin olarak okuyoruz.
      final jsonString = await rootBundle.loadString(casePath);
      
      // 2. Okuduğumuz metni (String) bir Map<String, dynamic> yapısına dönüştürüyoruz.
      final jsonMap = json.decode(jsonString);
      
      // 3. Bu Map'i, güncellediğimiz CaseModel.fromJson factory metoduna göndererek
      // tüm iç içe geçmiş nesneleriyle birlikte tam bir CaseModel nesnesi elde ediyoruz.
      return CaseModel.fromJson(jsonMap);

    } catch (e) {
      // Dosya okuma veya parse etme sırasında bir hata olursa,
      // hatayı konsola yazdırıp daha anlaşılır bir hata fırlatıyoruz.
      print('Vaka yüklenirken hata oluştu: $e');
      throw Exception('Vaka dosyası yüklenemedi: $casePath');
    }
  }

  // assets/cases klasöründeki tüm vakaları tarayıp bir liste döndüren fonksiyon.
  Future<List<Map<String, String>>> getAvailableCases() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      // Sadece 'assets/cases/' klasöründeki .json dosyalarını filtreliyoruz.
      final casePaths = manifestMap.keys
          .where((String key) => key.startsWith('assets/cases/'))
          .where((String key) => key.toLowerCase().endsWith('.json'))
          .toList();

      List<Map<String, String>> loadedCases = [];
      for (var path in casePaths) {
        final jsonString = await rootBundle.loadString(path);
        final jsonMap = json.decode(jsonString);
        // Her bir vaka için hem dosya yolunu hem de başlığını saklıyoruz.
        loadedCases.add({
          'path': path,
          // JSON'ın en dışındaki 'case' anahtarının altındaki 'title'ı alıyoruz.
          'title': jsonMap['case']?['title'] ?? 'İsimsiz Vaka',
        });
      }
      return loadedCases;

    } catch (e) {
      print('Vaka listesi alınırken hata oluştu: $e');
      return []; // Hata durumunda boş liste döndür.
    }
  }
}