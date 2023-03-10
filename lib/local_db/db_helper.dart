import 'package:rick_and_morty_characters_app/constants/constants.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "r_and_m_characters.db";
  static const _databaseVersion = 1;

  static const characterTable = 'characters';

  static const columnId = '_id';
  static const columnIdNumber = 'id';
  static const columnName = 'name';
  static const columnGender = 'gender';
  static const columnImage = 'image';
  static const columnStatus = 'status';
  static const columnSpecies = 'species';
  late Database _db;

  static Map<String, dynamic> toMap(CharacterModel characterModel) {
    return {
      columnIdNumber: int.parse(characterModel.id),
      columnName: characterModel.name,
      columnGender: characterModel.gender,
      columnImage: characterModel.image,
      columnStatus: characterModel.status,
      columnSpecies: characterModel.species,
    };
  }

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $characterTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnIdNumber INTEGER NOT NULL,
            $columnGender TEXT NOT NULL,
            $columnImage TEXT NOT NULL,
            $columnStatus TEXT NOT NULL,
            $columnSpecies TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    try {
      int exist = await queryRowCount(row[columnIdNumber]);
      if (exist > 0) {
        return update(row);
      } else {
        return await _db.insert(characterTable, row);
      }
    } catch (e) {
      print('error $e');
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(characterTable);
  }

  Future<List<Map<String, dynamic>>> filter(
      String query, String filterBy) async {
    String filterByColumn = _filterByColumn(filterBy);
    final results = await _db.query(characterTable,
        where: '$filterByColumn LIKE ?', whereArgs: ['%$query%']);
    return results;
  }

  String _filterByColumn(String filter) {
    switch (filter) {
      case Constants.FILTER_BY_NAME:
        return columnName;
      case Constants.FILTER_BY_SPECIES:
        return columnSpecies;
      case Constants.FILTER_BY_STATUS:
        return columnStatus;
      default:
        return '';
    }
  }

  Future<int> queryRowCount(int id) async {
    final results = await _db.rawQuery(
        'SELECT COUNT(*) FROM $characterTable where $columnIdNumber = $id');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnIdNumber];
    return await _db.update(
      characterTable,
      row,
      where: '$columnIdNumber = ?',
      whereArgs: [id],
    );
  }
}
