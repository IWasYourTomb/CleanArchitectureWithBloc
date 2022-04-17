import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttercleanbloc/bloc/character_bloc.dart';
import 'package:fluttercleanbloc/data/model/character.dart';
import 'package:fluttercleanbloc/ui/widgets/custom_list_tile.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key ? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Character _characters;
  List<Results> _result = [];
  String currentSearch = '';
  int page = 1;

  Timer? search;

  bool _isPagination = false;
  final RefreshController refreshController = RefreshController();

  final _storage = HydratedBlocOverrides.current?.storage;

 @override
  void initState() {
    if(_storage.runtimeType.toString().isEmpty){
      if(_result.isEmpty) {
        context.read<CharacterBloc>()
            .add(const CharacterEvent.fetch(name: '', page: 1));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   final state = context.watch<CharacterBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 40, left: 16, right: 16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(86, 86, 86, 0.8),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              hintText: 'Поиск',
              hintStyle: const TextStyle(color: Colors.white)
            ),
            onChanged: (value){
              page = 1;
              _result = [];
              currentSearch = value;

              search?.cancel();
              search = Timer(const Duration(microseconds: 500), (){
                context
                .read<CharacterBloc>()
                    .add(CharacterEvent.fetch(name: value, page: page));
              });
            },
          ),
        ),
        Expanded(
            child: state.when(
                loading: (){
                  if(!_isPagination){
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const[
                          CircularProgressIndicator(strokeWidth: 2),
                          SizedBox(width: 10),
                          Text('Загрузка...')
                        ],
                      ),
                    );
                  }else{
                    return _customListView(_result);
                  }
                },
                loaded: (characterLoaded){
                  _characters = characterLoaded;
                  if(_isPagination){
                    _result.addAll(_characters.results);
                    refreshController.loadComplete();
                    _isPagination = false;
                  }else{
                    _result = _characters.results;
                  }
                  return _result.isNotEmpty
                      ? _customListView(_result)
                      : const SizedBox();
                },
                error: () => const Text('Ничего не найдено')
            )
        )
      ],
    );
  }

  Widget _customListView(List<Results> currentResults) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: () {
        _isPagination = true;
        page++;
        if (page <= _characters.info.pages) {
          context.read<CharacterBloc>().add(CharacterEvent.fetch(
              name: currentSearch, page: page));
        } else {
          refreshController.loadNoData();
        }
      },
      child: ListView.separated(
        itemCount: currentResults.length,
        separatorBuilder: (_, index) => const SizedBox(height: 5),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final result = currentResults[index];
          return Padding(
            padding:
            const EdgeInsets.only(right: 16, left: 16, top: 3, bottom: 3),
            child: CustomListTile(result: result),
          );
        },
      ),
    );
  }
}
