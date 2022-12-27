import 'dart:io';

abstract class InternetConnectivityInterface {
  Future<List<InternetAddress>> lookup(String host);
}
