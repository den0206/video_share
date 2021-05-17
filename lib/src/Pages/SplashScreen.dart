import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Developed by me"),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                child: GestureDetector(
                  child: Text("Google.com"),
                  onTap: () async {
                    const url = "https://google.com";
                    if (await canLaunch(url)) {
                      await launch(
                        url,
                        forceSafariVC: true,
                        forceWebView: true,
                        enableJavaScript: true,
                      );
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Demo Share"),
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/instagram_logo.png',
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ],
          )
        ],
      ),
    );
  }
}
