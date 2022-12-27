import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters_app/blocs/character_bloc.dart';
import 'package:rick_and_morty_characters_app/main.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/pages/character/character_detail_page.dart';
import 'package:rick_and_morty_characters_app/utils/extensions/extensions.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  void initState() {
    getIt<CharacterBloc>().getCharacter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
              'https://media.zenfs.com/en/nerdist_761/a8bad44634c783d662e8732922dc425a',
              fit: BoxFit.cover,
            )),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Rick and Morty characters',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28.0),
              ),
            ),
          ),
          StreamBuilder<List<CharacterModel>>(
            stream: getIt<CharacterBloc>().characters,
            builder: (BuildContext context,
                AsyncSnapshot<List<CharacterModel>> snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              }
              return SliverPadding(
                padding: const EdgeInsets.only(top: 10.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      CharacterModel characterModel = snapshot.data![index];
                      return ListTile(
                        onTap: () => context.pushScreen(CharacterDetailPage(
                          characterModel: characterModel,
                        )),
                        leading: Image.network(
                          characterModel.image,
                          width: 60.0,
                          height: 60.0,
                        ),
                        title: Text(characterModel.name),
                        subtitle: Text(characterModel.gender),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
