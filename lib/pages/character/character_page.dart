import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rick_and_morty_characters_app/commons/search_widget.dart';
import 'package:rick_and_morty_characters_app/main.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/pages/character/character_detail_page.dart';
import 'package:rick_and_morty_characters_app/utils/extensions/extensions.dart';
import '../../blocs/character_bloc.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  final _numberOfPostsPerRequest = 20;
  final _searchController = TextEditingController();

  final PagingController<int, CharacterModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<CharacterModel> character =
          await getIt<CharacterBloc>().getCharacter(pageKey);
      final isLastPage = character.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(character);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(character, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty characters"),
        elevation: 1.0,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync((){
          _pagingController.refresh();
          context.clearFocus();
        }),
        child: Column(
          children: [
            SearchWidget(
              controller: _searchController,
              onChanged: (value){
                print(value);
              },
            ),
            Expanded(
              child: PagedListView<int, CharacterModel>.separated(
                pagingController: _pagingController,
                padding: const EdgeInsets.only(top: 20.0),
                builderDelegate: PagedChildBuilderDelegate<CharacterModel>(
                  itemBuilder: (context, item, index) => ListTile(
                    onTap: () => context.pushScreen(CharacterDetailPage(
                      characterModel: item,
                    )),
                    leading: Image.network(
                      item.image,
                      width: 60.0,
                      height: 60.0,
                    ),
                    title: Text(item.name),
                    subtitle: Text(item.gender),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
