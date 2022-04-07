import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wotla/features/game/view/game_page.dart';
import 'package:wotla/data/providers/date_provider.dart';
import 'package:wotla/data/repositories/wotla_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WOTLA',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.red,
          onPrimary: Colors.white,
          secondary: Colors.red,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: RepositoryProvider(
        create: (context) => WotlaRepository(
          WotlaSharedPreferences(
            SharedPreferences.getInstance(),
          ),
          DateProvider(),
        ),
        child: const GamePage(),
      ),
    );
  }
}
