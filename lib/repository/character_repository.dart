import 'package:rick_and_morty_characters_app/models/ws_response.dart';
import 'package:rick_and_morty_characters_app/services/character_service.dart';

class CharacterRepository {
  final CharacterApi _characterApi = CharacterService();

  Future<WsResponse> getAll(int page) {
    return _characterApi.getAll(page);
  }

  Future<WsResponse> filter(String query, int page, String filterBy) {
    return _characterApi.filter(query, page,filterBy);
  }
}
