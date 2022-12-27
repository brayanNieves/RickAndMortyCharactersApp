import 'dart:io';

import 'package:rick_and_morty_characters_app/utils/custom_connectivity/custom_connectivity.dart';
import 'package:rick_and_morty_characters_app/utils/custom_connectivity/custom_connectivity_interface.dart';

class ConnectivityAdapter implements CustomConnectivity {
  @override
  Future<bool> isConnected() async {
    try {
      final result =
          await const _InternetConnectivityImpl().lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return false;
  }
}

class _InternetConnectivityImpl implements InternetConnectivityInterface {
  const _InternetConnectivityImpl();

  @override
  Future<List<InternetAddress>> lookup(String host) =>
      InternetAddress.lookup(host);
}
