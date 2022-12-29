import 'dart:async';

import 'package:rick_and_morty_characters_app/blocs/bloc.dart';
import 'package:rick_and_morty_characters_app/local_db/db_helper.dart';
import 'package:rick_and_morty_characters_app/main.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/models/ws_response.dart';
import 'package:rick_and_morty_characters_app/repository/character_repository.dart';
import 'package:rick_and_morty_characters_app/utils/custom_connectivity/conectivity_adapter.dart';

class CharacterBloc extends Bloc {
  final _characterRepository = CharacterRepository();
  final _characterQueryController = StreamController<List<CharacterModel>>();
  final _connectivity = ConnectivityAdapter();

  Stream<List<CharacterModel>> get characters =>
      _characterQueryController.stream;
  late Stream<CharacterModel> articlesStream;

  Future<List<CharacterModel>> getCharacter(int pageKey) async {
    WsResponse response = await _characterRepository.getAll(pageKey);
    if (response.success) {
      CharacterModel characterModel = response.data;
      _insertCharacterInLocalDb(characterModel.characters);
      return characterModel.characters;
    }
    return [];
  }

  Future<void> _insertCharacterInLocalDb(
      List<CharacterModel> characters) async {
    if (await _connectivity.isConnected()) {
      int count = characters.length;
      if (count > 0) {
        characters.forEach((element) async {
          await getIt<DatabaseHelper>().insert(DatabaseHelper.toMap(element));
        });
      }
    }
  }

  Future<List<CharacterModel>> filterCharacter(
      String query, int page, String filterBy) async {
    WsResponse response =
        await _characterRepository.filter(query, page, filterBy);
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
