import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, String>> loadEnvFile(String path) async {
  await dotenv.load(fileName: path);
  return dotenv.env;
}
