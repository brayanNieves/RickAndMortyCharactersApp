class CharacterModel {
  late final String id;
  late final String name;
  late final String gender;
  late final String image;
  late List<CharacterModel> characters = [];

  CharacterModel(
      {required this.id,
      required this.name,
      required this.gender,
      required this.image});

  CharacterModel.fromJson(dynamic json) {
    List results = json['characters']['results'];
    characters = results
        .map((e) => CharacterModel(
            id: e['id'],
            name: e['name'],
            gender: e['gender'],
            image: e['image']))
        .toList();
  }
}
