import 'package:centralized_system_web/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'consts/theme_data.dart';

import 'controllers/menu_controller.dart';
import 'inner_screens/add_prod.dart';
import 'providers/dark_theme_provider.dart';

// import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
     apiKey: "AIzaSyDgPOvU71xx1pe3xM-odE3OUYlYxWLKA4k",

      authDomain: "centralizedsystem-c0e92.firebaseapp.com",

      projectId: "centralizedsystem-c0e92",

      storageBucket: "centralizedsystem-c0e92.appspot.com",

      messagingSenderId: "1096752220273",

      appId: "1:1096752220273:web:7595832d410d05ccb833d0",

      measurementId: "G-P2FDRY20KY"
    ),
  );
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Center(
                child: Text('App is being initialized'),
              ),
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Center(
                child: Text('An error has been occured ${snapshot.error}'),
              ),
            ),
          ),
        );
      }
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MenuControllers(),
          ),
          ChangeNotifierProvider(
            create: (_) {
              return themeChangeProvider;
            },
          ),
        ],
        child: Consumer<DarkThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Grocery',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const MainScreen(),
                routes: {
                  UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),
                });
          },
        ),
      );
    });
  }
}
