import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters_app/blocs/character_bloc.dart';
import 'package:rick_and_morty_characters_app/local_db/db_helper.dart';
import 'package:rick_and_morty_characters_app/pages/character/character_page.dart';
import 'package:rick_and_morty_characters_app/services/api/api_service.dart';
import 'package:rick_and_morty_characters_app/utils/env.dart';
import 'package:get_it/get_it.dart';

Map<String, String>? env;
final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  env = await loadEnvFile('assets/env/.env');
  getIt.registerSingleton<CharacterBloc>(CharacterBloc(), signalsReady: true);
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper(), signalsReady: true);
  await getIt<DatabaseHelper>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CharacterPage(),
    );
  }
}
