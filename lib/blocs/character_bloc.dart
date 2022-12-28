import 'dart:async';

import 'package:rick_and_morty_characters_app/blocs/bloc.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/models/ws_response.dart';
import 'package:rick_and_morty_characters_app/repository/character_repository.dart';

class CharacterBloc extends Bloc {
  final _characterRepository = CharacterRepository();
  final _characterQueryController = StreamController<List<CharacterModel>>();

  Stream<List<CharacterModel>> get characters =>
      _characterQueryController.stream;
  late Stream<CharacterModel> articlesStream;

  Future<List<CharacterModel>> getCharacter(int pageKey) async {
    WsResponse response = await _characterRepository.getAll(pageKey);
    if (response.success) {
      CharacterModel characterModel = response.data;
      _characterQueryController.add(characterModel.characters);
      return characterModel.characters;
    }
    return [];
  }

  Future<List<CharacterModel>> filterCharacter(
      String query, int page, String filterBy) async {
    WsResponse response = await _characterRepository.filter(query, page,filterBy);
    _characterQueryController.add([]);
    if (response.success) {
      CharacterModel characterModel = response.data;
      _characterQueryController.add(characterModel.characters);
      return characterModel.characters;
    }
    return [];
  }

  @override
  void dispose() {
    _characterQueryController.close();
  }
}
