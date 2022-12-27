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

  Future<void> getCharacter() async {
    WsResponse response = await _characterRepository.getAll();
    if (response.success) {
      CharacterModel characterModel = response.data;
      _characterQueryController.add(characterModel.characters);
    }
  }

  @override
  void dispose() {
    _characterQueryController.close();
  }
}
