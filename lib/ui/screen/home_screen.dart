import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercleanbloc/bloc/character_bloc.dart';
import 'package:fluttercleanbloc/data/repository/character_repository.dart';

import 'search_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key ? key, required this.title}) : super(key: key);

  final String title;
  final repository = CharacterRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CharacterBloc(repository: repository),
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: const SearchPage(),
        ),
      ),
    );
  }
}
