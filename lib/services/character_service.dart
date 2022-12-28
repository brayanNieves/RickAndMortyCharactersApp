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
    bool connected = await connectivity.isConnected();
    // options: QueryOptions(
    //   document: gql(r'''
    //       query HeroForEpisode($ep: Episode!) {
    //         hero(episode: $ep) {
    //           __typename
    //           name
    //           ... on Droid {
    //             primaryFunction
    //           }
    //           ... on Human {
    //             height
    //             homePlanet
    //           }
    //         }
    //       }
    //     '''),
    //   variables: <String, String>{
    //     'ep': episodeToJson(episode),
    //   },
    // );
    dynamic resp = await callApi(
      document: gql(
        r'''
      query {
         characters (page: 1) {
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
      ''',
      ),
      variables: <String, String>{'page': '1'},
    );
    return WsResponse(data: CharacterModel.fromJson(resp));
  }

  @override
  Future<WsResponse> filter(String searchValue, int page) async {
    final queryVariables = '''
    {
      "filter": {
        "name": $searchValue
      }
    }
    ''';
    dynamic query = r'''
      query {
         characters (page: 1, filter: { name: "" }) {
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
      //variables: queryVariables,
    );
    return WsResponse(data: CharacterModel.fromJson(resp));
  }
}
