import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_characters_app/blocs/character_bloc.dart';
import 'package:rick_and_morty_characters_app/local_db/db_helper.dart';
import 'package:rick_and_morty_characters_app/main.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/utils/env.dart';

void main() {
  Map<String, dynamic> actual = {
    "characters": {
      'results': [
        {
          'id': '1',
          'name': 'Rick Sanchez',
          'status': 'Alive',
          'species': 'Human',
          'gender': 'Male',
          'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg'
        },
      ]
    },
  };
  late CharacterBloc characterBloc;
  setUp(() async {
    characterBloc = CharacterBloc();
    env = await loadEnvFile('assets/env/.env');
    getIt.registerSingleton<CharacterBloc>(CharacterBloc(), signalsReady: true);
    getIt.registerSingleton<DatabaseHelper>(DatabaseHelper(),
        signalsReady: true);
  });

  test('Character Test', () async {
    List<CharacterModel> character =
        await characterBloc.getCharacter(1, insertIntoLocalDb: false);
    expect(CharacterModel.fromJson(actual).characters, character);
  });

  test('Character filter', () async {
    List<CharacterModel> character =
        await characterBloc.filterCharacter('Ricky', 1, 'name');
    expect(CharacterModel.fromJson(actual).characters, character);
  });
}
