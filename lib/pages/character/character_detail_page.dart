import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters_app/models/character_model.dart';

class CharacterDetailPage extends StatefulWidget {
  final CharacterModel characterModel;

  const CharacterDetailPage({Key? key, required this.characterModel})
      : super(key: key);

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraint) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                  widget.characterModel.image,
                  fit: BoxFit.cover,
                )),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.characterModel.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 28.0),
                            ),
                          ),
                          Chip(
                            label: Text(
                              widget.characterModel.status,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.characterModel.gender,
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
