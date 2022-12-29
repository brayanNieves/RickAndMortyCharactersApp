import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rick_and_morty_characters_app/commons/search_widget.dart';
import 'package:rick_and_morty_characters_app/main.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';
import 'package:rick_and_morty_characters_app/models/filter_model.dart';
import 'package:rick_and_morty_characters_app/pages/character/character_detail_page.dart';
import 'package:rick_and_morty_characters_app/pages/character/filter_character_page.dart';
import 'package:rick_and_morty_characters_app/utils/bottom_sheet_utils.dart';
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
  bool filter = false;
  String query = '';

  final PagingController<int, CharacterModel> _pagingController =
      PagingController(firstPageKey: 1);

  late ValueNotifier<FilterModel?> _filterNotifier;

  @override
  void initState() {
    _filterNotifier = ValueNotifier(null);
    _pagingController.addPageRequestListener((pageKey) {
      if (filter) {
        _filterCharacter(query, pageKey);
      } else {
        _fetchCharacter(pageKey);
      }
    });
    super.initState();
  }

  Future<void> _fetchCharacter(int pageKey) async {
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

  Future<void> _filterCharacter(String query, int pageKey) async {
    try {
      List<CharacterModel> character = await getIt<CharacterBloc>()
          .filterCharacter(
              query, pageKey, _filterNotifier.value?.filterBy ?? '');
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
        onRefresh: () => Future.sync(() {
          filter = false;
          context.clearFocus();
          _searchController.clear();
          _pagingController.refresh();
          _filterNotifier.value = null;
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: _filterNotifier,
              builder:
                  (BuildContext context, FilterModel? value, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWidget(
                      controller: _searchController,
                      enabled: value != null,
                      suffixIcon: IconButton(
                        onPressed: () {
                          BottomSheetUtils.open(context,
                                  widget: const FilterCharacterPage())
                              .then((value) {
                            if (value != null) {
                              _filterNotifier.value = value;
                            }
                          });
                        },
                        icon: const Icon(Icons.filter_list_sharp),
                      ),
                      onChanged: (value) {
                        filter = value.isNotEmpty;
                        query = value;
                        _pagingController.refresh();
                      },
                    ),
                    if (value != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Filter by',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Chip(
                                onDeleted: () {
                                  _filterNotifier.value = null;
                                  _searchController.clear();
                                  context.clearFocus();
                                },
                                label: Text(value.filterName)),
                          ],
                        ),
                      )
                  ],
                );
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
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.gender),
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                item.status,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Chip(
                              label: Text(
                                item.species,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
    _filterNotifier.dispose();
    super.dispose();
  }
}
