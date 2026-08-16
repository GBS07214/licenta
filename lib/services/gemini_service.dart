import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_message.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyAQ.Ab8RN6IoWBi-ozv4cJCli6FmSSRg3pr5k-OdTf28BUiaQA_O8Q';
  late final GenerativeModel _model;
  final List<ChatMessage> _chatHistory = [];

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(temperature: 0.7, topK: 40, topP: 0.95, maxOutputTokens: 1024),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      ],
    );
  }

  final String _systemPrompt = '''
Ești un asistent virtual specializat în îngrijirea bebelușilor și sfaturi pentru părinți.
Rol: Oferă sfaturi calde, sigure și bazate pe dovezi medicale despre îngrijirea bebelușilor.
Ton: Empatic, încurajator și prietenos.
Limbă: Întotdeauna răspunde în limba română.
Restricții:
- Nu oferi diagnostice medicale
- Recomandă consultarea unui pediatru pentru probleme serioase
- Fii pozitiv și încurajator
- Oferă sfaturi practice și aplicabile
''';

  Future<String> sendMessage(String userMessage) async {
    try {
      final content = [
        Content.text(_systemPrompt),
        ..._chatHistory.map((msg) => Content.text('${msg.isUser ? "Utilizator" : "Asistent"}: ${msg.text}')),
        Content.text('Utilizator: $userMessage'),
      ];

      final response = await _model.generateContent(content);
      final aiResponse = response.text ?? 'Ne pare rău, nu am putut genera un răspuns.';

      _chatHistory.add(ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()));
      _chatHistory.add(ChatMessage(text: aiResponse, isUser: false, timestamp: DateTime.now()));

      return aiResponse;
    } catch (e) {
      return 'A apărut o eroare: ${e.toString()}';
    }
  }

  void clearHistory() => _chatHistory.clear();
  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);
}
