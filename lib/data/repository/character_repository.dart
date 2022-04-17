import 'dart:convert';

import 'package:fluttercleanbloc/data/model/character.dart';
import 'package:http/http.dart' as http;

class CharacterRepository{
  final url = 'https://rickandmortyapi.com/api/character';

  Future<Character> getCharacter(int page, String name) async{
    try{
      var response = await http.get(Uri.parse(url));

      var jsonResult = json.decode(response.body);

      return Character.fromJson(jsonResult);
    }catch(e){
      throw Exception(e.toString());
    }
  }
}