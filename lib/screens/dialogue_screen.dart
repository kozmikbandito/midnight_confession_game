import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../engine/game_engine.dart';

// Mesajları tutmak için basit bir sınıf.
class ChatMessage {
  final String text;
  final bool isPlayer;

  ChatMessage({required this.text, required this.isPlayer});
}

class DialogueScreen extends StatefulWidget {
  final GameEngine gameEngine;
  final CharacterModel character;

  const DialogueScreen({super.key, required this.gameEngine, required this.character});

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  final TextEditingController _textController = TextEditingController();
  // GÜNCELLEME: Konuşma geçmişini artık GameState'ten alacağız.
  late List<ChatMessage> _messages;
  bool _isResponding = false; // Bot'un cevap verip vermediğini takip eder.

  @override
  void initState() {
    super.initState();
    // Konuşma geçmişini yükle veya yeni bir tane başlat.
    _messages = widget.gameEngine.gameState.conversationHistories[widget.character.id] ?? [];
    if (_messages.isEmpty) {
      // İlk mesajı ekle
      final initialMessage = ChatMessage(text: 'Merhaba dedektif, ne öğrenmek istiyorsun?', isPlayer: false);
      widget.gameEngine.gameState.addMessageToHistory(widget.character.id, initialMessage);
      _messages.insert(0, initialMessage);
    }
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isResponding) return;
    _textController.clear();

    setState(() {
      _isResponding = true;
      // Oyuncunun mesajı anında ekranda gösterilir.
      // GameState'e ekleme işini motor yaptığı için burada sadece UI'ı güncelliyoruz.
       _messages.insert(0, ChatMessage(text: text, isPlayer: true));
    });

    // YENİ: Oyun motorunu kullanarak cevap alıyoruz.
    final botResponse = await widget.gameEngine.processPlayerMessage(
      characterId: widget.character.id,
      playerMessage: text,
    );

    setState(() {
      _messages.insert(0, botResponse);
      _isResponding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _buildMessageItem(_messages[index]),
            ),
          ),
          if (_isResponding)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          const Divider(height: 1.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _isResponding ? null : _handleSubmitted,
                decoration: const InputDecoration.collapsed(hintText: "Sorunuzu yazın..."),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isResponding ? null : () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isPlayer ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (!message.isPlayer)
            CircleAvatar(child: Text(widget.character.name[0])),
          
          const SizedBox(width: 10),
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: message.isPlayer ? Colors.teal : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

           const SizedBox(width: 10),

          if (message.isPlayer)
            const CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }
}