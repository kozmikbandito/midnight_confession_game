import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/case_model.dart';

// Bu sınıf, vaka dosyalarını yüklemek ve parse etmekten sorumludur.
class CaseLoaderService {

  // Belirtilen dosya yolundan bir vaka yükler.
  Future<CaseModel> loadCase(String casePath) async {
    try {
      // 1. Projenin asset'lerinden JSON dosyasını metin olarak okuyoruz.
      final jsonString = await rootBundle.loadString(casePath);
      
      // 2. Okuduğumuz metni (String) bir Map<String, dynamic> yapısına dönüştürüyoruz.
      final jsonMap = json.decode(jsonString);
      
      // 3. Bu Map'i, daha önce oluşturduğumuz CaseModel.fromJson factory metoduna göndererek
      // tam teşekküllü bir CaseModel nesnesi elde ediyoruz.
      return CaseModel.fromJson(jsonMap);

    } catch (e) {
      // Dosya okuma veya parse etme sırasında bir hata olursa,
      // hatayı konsola yazdırıp daha anlaşılır bir hata fırlatıyoruz.
      print('Vaka yüklenirken hata oluştu: $e');
      throw Exception('Vaka dosyası yüklenemedi: $casePath');
    }
  }

  // İleride, 'assets/cases' klasöründeki tüm vakaları listeleyen
  // bir fonksiyon da buraya eklenebilir.
  // Future<List<String>> getAvailableCases() async { ... }
}