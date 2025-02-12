import 'imports.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: MaterialApp(
        title: 'Hollows Go',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PreHomeScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
