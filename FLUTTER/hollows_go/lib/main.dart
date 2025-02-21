import 'package:hollows_go/providers/user_provider.dart';
import 'package:hollows_go/screens/mapscreen.dart';

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
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
