import 'package:flutter/material.dart';
import 'package:fluttercleanbloc/bloc_observable.dart';
import 'package:fluttercleanbloc/ui/screen/home_screen.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory()
  );

  HydratedBlocOverrides.runZoned(() => runApp(const MyApp()),
    blocObserver: CharacterBlocObservable(),
    storage: storage
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(title: 'Rick and Morty',),
    );
  }
}

