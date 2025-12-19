import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class AssistantRemoteDataSource {
  Future<String> getGeminiResponse(String prompt);
}

@LazySingleton(as: AssistantRemoteDataSource)
class AssistantRemoteDataSourceImpl implements AssistantRemoteDataSource {
  late GenerativeModel _model;

  AssistantRemoteDataSourceImpl() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  @override
  Future<String> getGeminiResponse(String prompt) async {
    const promptDef = '''
Tu es un expert plus de 20 ans en Contrat de toute sorte. Réponds uniquement aux prompts liés aux Contrat de manière précise,concise et ordonnee, n'utilise pas de ** dans test reponse.
Si le prompt ne concerne pas le Contrat, corrige l'utilisateur et ne donne pas la reponse
''';
    final content = [Content.text('$promptDef\nPrompt : $prompt')];
    final response = await _model.generateContent(content);
    return response.text ?? 'Désolé, je n\'ai pas pu générer de réponse.';
  }
}
