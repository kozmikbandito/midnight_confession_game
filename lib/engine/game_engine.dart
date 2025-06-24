import 'game_state_service.dart';
import '../screens/dialogue_screen.dart';
import '../services/gemini_service.dart';

class GameEngine {
  final GameStateService gameState;
  final GeminiService _geminiService;

  GameEngine({required this.gameState}) : _geminiService = GeminiService();

  Future<ChatMessage> processPlayerMessage({
    required String characterId,
    required String playerMessage,
  }) async {
    gameState.addMessageToHistory(
        characterId, ChatMessage(text: playerMessage, isPlayer: true));

    final character = gameState.caseData.characters
        .firstWhere((c) => c.id == characterId);

    String finalPrompt = "${character.basePrompt}\n\n";

    for (var info in character.information) {
      bool isUnlocked = false;
      if (info.triggers.isNotEmpty) {
        final triggerEvidenceId = info.triggers.first.evidence?.id;
        if (triggerEvidenceId != null && gameState.hasFoundEvidence(triggerEvidenceId)) {
          isUnlocked = true;
        }
      }
      
      if (isUnlocked) {
        finalPrompt += "BİLGİ: Oyuncu bir kanıt bulduğu için artık şu sırrı biliyor ve sen de bunu itiraf etmek zorundasın: ${info.unlockedPrompt}\n";
        gameState.addUnlockedInfo(info.id);
      } else {
        finalPrompt += "KURAL: Oyuncu şu konu hakkında soru sorarsa, şöyle davran: ${info.lockedPrompt}\n";
      }
    }

    final history = gameState.conversationHistories[characterId] ?? [];
    for (var message in history) {
      final role = message.isPlayer ? "Oyuncu" : "Sen";
      finalPrompt += "$role: ${message.text}\n";
    }

    finalPrompt += "Oyuncu: $playerMessage\nSen: ";

    final botResponseText = await _geminiService.getBotResponse(finalPrompt);
    final botMessage = ChatMessage(text: botResponseText, isPlayer: false);
    gameState.addMessageToHistory(characterId, botMessage);
    return botMessage;
  }

  String searchLocation(int locationId) {
    final evidenceInLocation = gameState.caseData.evidence
        .where((e) => e.locationId == locationId)
        .toList();

    final newEvidence = evidenceInLocation
        .where((e) => !gameState.hasFoundEvidence(e.id))
        .toList();

    if (newEvidence.isNotEmpty) {
      final foundEvidence = newEvidence.first;
      gameState.addDiscoveredEvidence(foundEvidence.id);
      return "Bir ipucu buldun: ${foundEvidence.name}. Detaylar not defterine eklendi.";
    } else {
      return "Etrafı dikkatle inceledin ama göze çarpan yeni bir şey bulamadın.";
    }
  }
}