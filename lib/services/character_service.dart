import 'package:graphql/client.dart';
import 'package:rick_and_morty_characters_app/constants/constants.dart';
import 'package:rick_and_morty_characters_app/local_db/db_helper.dart';
import 'package:rick_and_morty_characters_app/main.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/models/ws_response.dart';
import 'package:rick_and_morty_characters_app/services/api/api_service.dart';

mixin CharacterApi {
  Future<WsResponse> getAll(int page);

  Future<WsResponse> filter(String query, int page, String filterBy);
}

class CharacterService extends ApiService implements CharacterApi {
  @override
  Future<WsResponse> getAll(int page) async {
    bool connected = await connectivity.isConnected();
    if (!connected) {
      List<Map<String, dynamic>> characters =
          await getIt<DatabaseHelper>().queryAllRows();
      return WsResponse(
          data: CharacterModel.fromJson(null,
              characters: characters
                  .map((e) => CharacterModel(
                      id: '${e['id']}',
                      status: e['status'],
                      name: e['name'],
                      species: e['species'],
                      gender: e['gender'],
                      image: e['image']))
                  .toList()));
    }
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
      image,
      status,
      species
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
  Future<WsResponse> filter(
      String searchValue, int page, String filterBy) async {
    bool connected = await connectivity.isConnected();
    if (!connected) {
      List<Map<String, dynamic>> characters =
          await getIt<DatabaseHelper>().filter(searchValue, filterBy);
      return WsResponse(
          data: CharacterModel.fromJson(null,
              characters: characters
                  .map((e) => CharacterModel(
                      id: '${e['id']}',
                      status: e['status'],
                      name: e['name'],
                      species: e['species'],
                      gender: e['gender'],
                      image: e['image']))
                  .toList()));
    }
    dynamic query = getFilter(filterBy);
    dynamic resp = await callApi(
      document: gql(
        query,
      ),
      variables: <String, dynamic>{'query': searchValue, 'page': page},
    );
    return WsResponse(data: CharacterModel.fromJson(resp));
  }

  String getFilter(String filter) {
    switch (filter) {
      case Constants.FILTER_BY_NAME:
        return r'''
      query filter($query:String!, $page:Int!) {
         characters (page: $page, filter: { name: $query}) {
        info {
          count
       }
      results {
      id,
      name,
      gender,
      image,
      status,
      species
       }
     }
     }
      ''';
      case Constants.FILTER_BY_SPECIES:
        return r'''
      query filter($query:String!, $page:Int!) {
         characters (page: $page, filter: { species: $query }) {
        info {
          count
       }
      results {
      id,
      name,
      gender,
      image,
      status,
      species
       }
     }
     }
      ''';
      case Constants.FILTER_BY_STATUS:
        return r'''
      query filter($query:String!, $page:Int!) {
         characters (page: $page, filter: { status: $query}) {
        info {
          count
       }
      results {
      id,
      name,
      gender,
      image,
      status,
      species
       }
     }
     }
      ''';
      default:
        return '';
    }
  }
}
