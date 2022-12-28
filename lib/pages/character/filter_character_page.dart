import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters_app/constants/constants.dart';
import 'package:rick_and_morty_characters_app/models/filter_model.dart';

class FilterCharacterPage extends StatefulWidget {
  const FilterCharacterPage({Key? key}) : super(key: key);

  @override
  State<FilterCharacterPage> createState() => _FilterCharacterPageState();
}

class _FilterCharacterPageState extends State<FilterCharacterPage> {
  List<FilterModel> filters = [
    FilterModel(filterBy: Constants.FILTER_BY_NAME, filterName: 'Name'),
    FilterModel(filterBy: Constants.FILTER_BY_STATUS, filterName: 'Status'),
    FilterModel(filterBy: Constants.FILTER_BY_SPECIES, filterName: 'Species')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 12.0,
          ),
          Center(
            child: Container(
              width: 40.0,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text(
            'Filters',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filters.length,
              key: const Key('filter-character-key'),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filters[index].filterName),
                  trailing: Icon(filters[index].selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off),
                  onTap: () {
                    for (var element in filters) {
                      element.selected = false;
                    }
                    setState(() {
                      filters[index].selected = !filters[index].selected;
                    });
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              color: Colors.blueAccent,
              child: TextButton(
                  onPressed: () {
                    if (filters
                        .where((element) => element.selected)
                        .isNotEmpty) {
                      Navigator.pop(context,
                          filters.singleWhere((element) => element.selected));
                    }
                  },
                  child: const Text('Apply',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
            ),
          )
        ],
      ),
    );
  }
}
