import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // --- ÖNEMLİ GÜVENLİK UYARISI ---
  // API anahtarını doğrudan koda yazmak, test aşaması için kabul edilebilir
  // ancak canlıya alınacak bir uygulama için GÜVENLİ DEĞİLDİR.
  static const String _apiKey = "AIzaSyBuNF3VdjwzZekmzWirvjPr4-V0Omdsadg";

  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: _apiKey,
  );

  Future<String> getBotResponse(String prompt) async {
    // DÜZELTME: API anahtarının, ilk halindeki varsayılan değer olup olmadığını kontrol ediyoruz.
    // Bu, anahtarı değiştirmeyi unutup unutmadığımızı anlamanın en doğru yoludur.
    if (_apiKey == "SENIN_GEMINI_API_ANAHTARIN" || _apiKey.isEmpty) {
      return "HATA: Gemini API Anahtarı girilmemiş. Lütfen gemini_service.dart dosyasındaki _apiKey değişkenini kendi anahtarınızla güncelleyin.";
    }

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Anlaşılan o ki, söyleyecek bir şey bulamıyorum.";

    } catch (e) {
      // Hata mesajını daha anlaşılır hale getirelim.
      print("Gemini API Hatası: $e");
      if (e.toString().contains('API key not valid')) {
        return "API Anahtarı geçersiz görünüyor. Lütfen anahtarınızı kontrol edin.";
      }
      return "Kafam biraz karışık, dedektif. Bu soruyu daha sonra tekrar sorabilir misin?";
    }
  }
}
