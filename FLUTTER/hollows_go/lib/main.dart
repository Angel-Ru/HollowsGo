import 'package:hollows_go/providers/missions_provider.dart';
import 'package:hollows_go/service/audioservice.dart';

import 'imports.dart';
import 'providers/habilitat_provider.dart';

/*
Aquesta és la classe Main. En aquesta classe es creen les rutes anomenades de l'aplicació i es defineix el tema.
A més, s'afegeixen els providers que es faran servir a tota l'aplicació.
*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AudioService.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DialogueProvider()),
        ChangeNotifierProvider(create: (_) => GachaProvider()),
        ChangeNotifierProvider(
            create: (_) => SkinsEnemicsPersonatgesProvider()),
        ChangeNotifierProvider(create: (_) => PerfilProvider()),
        ChangeNotifierProvider(create: (_) => MapDataProvider()),
        ChangeNotifierProvider(create: (_) => ArmesProvider()),
        ChangeNotifierProvider(create: (_) => CombatProvider()),
        ChangeNotifierProvider(create: (_) => VialsProvider()),
        ChangeNotifierProvider(create: (_) => HabilitatProvider()),
        ChangeNotifierProvider(create: (_) => MissionsProvider())
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
          '/map': (context) => Mapscreen(profileImagePath: ''),
          '/biblioteca': (context) => BibliotecaScreen(),
        },
      ),
    );
  }
}
