import 'game_state_service.dart';
import '../models/character_model.dart';
import '../models/relationship_model.dart';
import '../screens/dialogue_screen.dart';
import '../services/gemini_service.dart';

// Bu sınıf, oyunun tüm mantığını ve kurallarını yönetir.
class GameEngine {
  final GameStateService gameState;
  final GeminiService _geminiService;

  GameEngine({required this.gameState}) : _geminiService = GeminiService();

  // Oyuncunun mesajını işleyen ana fonksiyon.
  Future<ChatMessage> processPlayerMessage({
    required String characterId,
    required String playerMessage,
  }) async {
    // 1. Oyuncunun mesajını konuşma geçmişine ekle.
    gameState.addMessageToHistory(
        characterId, ChatMessage(text: playerMessage, isPlayer: true));

    // 2. O anki konuşulan karakteri bul.
    final character = gameState.caseData.characters
        .firstWhere((c) => c.id == characterId);

    // 3. Dinamik olarak o anki duruma özel bir prompt oluştur.
    final finalPrompt = _buildDynamicPrompt(character, playerMessage);

    print("--- GEMINI'YE GİDECEK OLAN NİHAİ PROMPT ---");
    print(finalPrompt);
    print("---------------------------------------------");

    // 4. Bu prompt'u Gemini API'ye gönder ve gerçek bir cevap al.
    final botResponseText = await _geminiService.getBotResponse(finalPrompt);

    final botMessage = ChatMessage(text: botResponseText, isPlayer: false);
    
    // 5. Bot'un cevabını da konuşma geçmişine ekle ve oyundaki olayları kontrol et.
    gameState.addMessageToHistory(characterId, botMessage);
    _checkForUnlocks(botResponseText);

    return botMessage;
  }

  // Gemini için dinamik olarak prompt oluşturan ana fonksiyon.
  String _buildDynamicPrompt(CharacterModel character, String playerMessage) {
    // a. Temel Kimlik: Karakterin kim olduğunu tanımla.
    String prompt = "SENİN ROLÜN: Sen ${character.name}'sın, ${character.age} yaşında, ${character.traits.join(', ')} özelliklerine sahip bir ${character.occupation}. Baş piyano eğitmeni Leonard Voss'un ölümünde bir ${character.roleInCase}'sın. Asla bir yapay zeka olduğunu belli etme.\n\n";

    // b. Psikolojik Durum: Karakterin güdülerini ve hislerini ekle.
    if (character.motive != null) {
      prompt += "PSİKOLOJİK DURUM: Senin en temel güdün şu: ${character.motive}. Bu durumu konuşmalarına yansıt ama asla doğrudan güdünü söyleme.\n\n";
    }

    // c. Mazeret Durumu: Karakterin mazeretini ve durumunu analiz et.
    prompt += "SAVUNMAN (ALIBI): Senin mazeretin, '${character.alibi.description}'. ";
    if (gameState.brokenAlibiCharacterIds.contains(character.id)) {
      prompt += "ACİL DURUM: Ancak bu mazeretin çürütüldü! Oyuncu yalan söylediğini biliyor. Bu yüzden panik içinde, savunmacı ve çelişkili konuşmalısın.\n\n";
    } else {
      prompt += "Bu mazeretini kendinden emin bir şekilde savun.\n\n";
    }

    // d. İlişki Analizi: Karakterin diğer kişilerle olan ilişkilerini tanımla.
    final relationships = gameState.caseData.relationships.where((r) => r.source == character.id || r.target == character.id).toList();
    if (relationships.isNotEmpty) {
      prompt += "İLİŞKİLERİN HAKKINDA BİLMEN GEREKENLER:\n";
      for (var rel in relationships) {
        // Find the name of the other character in the relationship
        String otherCharacterName = "Bilinmeyen Karakter";
        if (rel.source == character.id) {
          final other = gameState.caseData.characters.firstWhere((c) => c.id == rel.target, orElse: () => CharacterModel(id: '', name: 'Bilinmeyen Karakter', age: 0, occupation: '', roleInCase: '', traits: [], alibi: character.alibi, inventory: [])); // Provide a default AlibiModel
          otherCharacterName = other.name;
        } else {
          final other = gameState.caseData.characters.firstWhere((c) => c.id == rel.source, orElse: () => CharacterModel(id: '', name: 'Bilinmeyen Karakter', age: 0, occupation: '', roleInCase: '', traits: [], alibi: character.alibi, inventory: [])); // Provide a default AlibiModel
          otherCharacterName = other.name;
        }
        prompt += "- $otherCharacterName ile ilişkinin türü '${rel.type}' ve yoğunluğu '${rel.intensity}'. Ona göre davran. Notlar: ${rel.notes ?? 'Ek not yok.'}\n";
      }
      prompt += "\n";
    }
    
    // e. Konuşma Geçmişi ve Son Komut
    prompt += "KONUŞMA GEÇMİŞİ:\n";
    final history = gameState.conversationHistories[character.id] ?? [];
    // Son 6 mesajı alıp, doğru sıralamada (eskiden yeniye) ekliyoruz.
    for (var message in history.reversed.take(6)) {
      final role = message.isPlayer ? "Dedektif" : "Sen";
      prompt += "$role: ${message.text}\n";
    }

    prompt += "\nŞİMDİKİ GÖREVİN: Dedektifin aşağıdaki sorusuna, yukarıda belirtilen tüm kişilik özelliklerine, kurallara ve bilgilere sadık kalarak, doğal bir dil ile cevap ver.\n";
    prompt += "Dedektif: $playerMessage\nSen: ";

    return prompt;
  }

  // Sohbet cevabında bir ipucu olup olmadığını kontrol eder.
  void _checkForUnlocks(String botResponse) {
    // İleride, bot'un cevabını analiz edip yeni mekanların kilidini açan
    // veya yeni kanıtlar bulan bir mantık buraya eklenebilir.
    // Örneğin, bot "Kaan'ın gizli bir dağ evi vardı..." derse,
    // "dağ evi" kelimesini yakalayıp haritaya yeni bir mekan ekleyebiliriz.
  }

  // Mekan araştırma gibi diğer oyun motoru fonksiyonları buraya eklenecek.
  String searchLocation(String roomId) {
    // ...
    return "Arama sonucu.";
  }
}