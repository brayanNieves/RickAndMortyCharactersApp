import 'package:graphql/client.dart';
import 'package:rick_and_morty_characters_app/services/api/api_service.dart';

class CharacterService extends ApiService {
  void getCharacters() async {
    dynamic resp = await callApi(
        document: gql(
      r'''
      query {
  characters {
    info {
      count
    }
    results {
      name
    }
  }
}
      ''',
    ));
    print('getCharacters $resp');
  }
}
