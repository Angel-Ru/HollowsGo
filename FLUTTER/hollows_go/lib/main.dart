import 'imports.dart';

/*
Aquesta és la classe Main. En aquesta classe es creen les rutes anomenades de l'aplicació i es defineix el tema.
A més, s'afegeixen els providers que es faran servir a tota l'aplicació.
*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DialogueProvider()),
        ChangeNotifierProvider(
            create: (_) => SkinsEnemicsPersonatgesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hollows Go',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PreHomeScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/map': (context) => Mapscreen(
                profileImagePath: '',
              ),
        },
      ),
    );
  }
}
