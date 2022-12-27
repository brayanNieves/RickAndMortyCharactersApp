import 'package:graphql/client.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/models/ws_response.dart';
import 'package:rick_and_morty_characters_app/services/api/api_service.dart';

mixin CharacterApi {
  Future<WsResponse> getAll();
}

class CharacterService extends ApiService implements CharacterApi {
  @override
  Future<WsResponse> getAll() async {
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
    // ),
    dynamic resp = await callApi(
        document: gql(
      r'''
      query {
  characters (page:1) {
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
    ));
    return WsResponse(data: CharacterModel.fromJson(resp));
  }
}
