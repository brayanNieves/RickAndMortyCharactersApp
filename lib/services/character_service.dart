import 'package:graphql/client.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/models/ws_response.dart';
import 'package:rick_and_morty_characters_app/services/api/api_service.dart';

mixin CharacterApi {
  Future<WsResponse> getAll(int page);

  Future<WsResponse> filter(String query, int page);
}

class CharacterService extends ApiService implements CharacterApi {
  @override
  Future<WsResponse> getAll(int page) async {
    String query = r'''
      query getCharacter($page: Int!) {
         characters (page: $page) {
        info {
          count
       }
      results {
      id,
      name,
      gender,
      image
       }
     }
     }
      ''';
    dynamic resp = await callApi(
      document: gql(
        query,
      ),
      variables: <String, dynamic>{'page': page},
    );
    return WsResponse(data: CharacterModel.fromJson(resp));
  }

  @override
  Future<WsResponse> filter(String searchValue, int page) async {
    dynamic query = r'''
      query filter($query:String!, $page:Int!) {
         characters (page: $page, filter: { name: $query }) {
        info {
          count
       }
      results {
      id,
      name,
      gender,
      image
       }
     }
     }
      ''';
    dynamic resp = await callApi(
      document: gql(
        query,
      ),
      variables: <String, dynamic>{'query': searchValue, 'page': page},
    );
    return WsResponse(data: CharacterModel.fromJson(resp));
  }
}
