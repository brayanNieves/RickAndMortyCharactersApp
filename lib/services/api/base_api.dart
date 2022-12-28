import 'dart:async';
import 'package:graphql/client.dart';
import 'package:gql/ast.dart';
import 'package:rick_and_morty_characters_app/constants/error_constants.dart';
import 'package:rick_and_morty_characters_app/main.dart';
import 'package:rick_and_morty_characters_app/models/app_exception.dart';
import 'package:rick_and_morty_characters_app/utils/custom_connectivity/custom_connectivity.dart';

mixin BaseApi {
  CustomConnectivity get connectivity;

  Future<dynamic> callApi(
      {required DocumentNode document, Map<String, String>? variables}) async {
    if (!await connectivity.isConnected()) {
      throw AppException(code: ErrorConstants.NOT_INTERNET);
    }
    final Link link = HttpLink(
      env!['BASE_URL']!,
    );
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
    final QueryOptions options =
        QueryOptions(document: document, variables: variables ?? {});
    try {
      final QueryResult result = await client.query(options);
      return result.data;
    } catch (error) {
      rethrow;
    }
  }
}
