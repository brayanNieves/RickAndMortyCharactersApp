import 'dart:async';
import 'package:graphql/client.dart';
import 'dart:io' show stderr;
import 'package:gql/ast.dart';

class BaseApi {
  GraphQLClient getGithubGraphQLClient() {
    final Link link = HttpLink(
      'https://rickandmortyapi.com/graphql',
    );
    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  Future<dynamic> callApi({required DocumentNode document}) async {
    final GraphQLClient client = getGithubGraphQLClient();
    final QueryOptions options = QueryOptions(
      document: document,
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      stderr.writeln(result.exception.toString());
    }
  }
}
