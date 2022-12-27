import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/models/ws_response.dart';
import 'package:rick_and_morty_characters_app/services/character_service.dart';

class CharacterRepository {
  final CharacterApi _characterApi = CharacterService();

  Future<WsResponse> getAll() {
    return _characterApi.getAll();
  }
}