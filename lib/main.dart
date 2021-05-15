import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Pages/Auth/LoginPage.dart';
import 'package:video_share/src/Pages/Auth/SignUpPage.dart';
import 'package:video_share/src/Pages/HomePage.dart';
import 'package:video_share/src/Pages/RootPage.dart';
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
        ChangeNotifierProvider<UserState>(create: (context) => UserState())
      ],
      child: MaterialApp(
        title: 'Video Share',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.red[200],
        ),
        // home: SignUpPage(),
        home: RootPage(),
        routes: {
          LoginPage.id: (context) => LoginPage(),
          SignUpPage.id: (context) => SignUpPage(),
          HomePage.id: (context) => HomePage(),
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
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
        }

        if (snapshot.hasData) {
          return BranchPage();
        }

        return LoginPage();
      },
    );
  }
}
