import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Pages/Auth/LoginPage.dart';
import 'package:video_share/src/Pages/Auth/SignUpPage.dart';
import 'package:video_share/src/Pages/HomePage.dart';
import 'package:video_share/src/Pages/RootPage.dart';
import 'package:video_share/src/Pages/SplashScreen.dart';
import 'package:video_share/src/Pages/TabPage/EditPage.dart';
import 'package:video_share/src/Provider/UserState.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserState>(create: (context) => UserState()),
        ChangeNotifierProvider<TabPageModel>(
            create: (context) => TabPageModel()),
      ],
      child: MaterialApp(
        title: 'Video Share',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: globalPink,
        ),
        // home: SignUpPage(),
        home: RootPage(),
        routes: {
          LoginPage.id: (context) => LoginPage(),
          SignUpPage.id: (context) => SignUpPage(),
          TabPage.id: (context) => TabPage(),
          EditPage.id: (context) => EditPage()
        },
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();

          ///  Center(
          //     child: CircularProgressIndicator(backgroundColor: globalPink));
        }

        if (snapshot.hasData) {
          return BranchPage();
        }

        return LoginPage();
      },
    );
  }
}
