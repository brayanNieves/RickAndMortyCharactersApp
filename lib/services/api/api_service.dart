import 'package:rick_and_morty_characters_app/services/api/base_api.dart';
import 'package:rick_and_morty_characters_app/utils/custom_connectivity/conectivity_adapter.dart';
import 'package:rick_and_morty_characters_app/utils/custom_connectivity/custom_connectivity.dart';

abstract class ApiService with BaseApi {
  CustomConnectivity? _connectivity;

  @override
  CustomConnectivity get connectivity => _connectivity!;

  ApiService() {
    _connectivity = ConnectivityAdapter();
  }
}
