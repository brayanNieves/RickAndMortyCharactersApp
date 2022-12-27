import 'package:flutter/cupertino.dart';
import 'package:rick_and_morty_characters_app/blocs/bloc.dart';

abstract class BaseState<T extends StatefulWidget, K extends Bloc>
    extends State<T> {

  @override
  void initState() {
    super.initState();
  }
}
