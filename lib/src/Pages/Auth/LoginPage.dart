import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/CustomTextField.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Extension/Validations.dart';
import 'package:video_share/src/Pages/Auth/SignUpPage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>(debugLabel: '_LoginState');
  static const String id = "login";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginPageModel>(
      create: (context) => LoginPageModel(),
      builder: (context, snapshot) {
        return OverlayLoadingWidget(
          child: Scaffold(
            backgroundColor: Colors.red[200],
            body: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    "Welcome",
                    style: googleFont(size: 25, fw: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Login",
                    style: googleFont(size: 25, fw: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Consumer<LoginPageModel>(
                    builder: (context, model, child) {
                      return Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFields(
                                controller: model.emailController,
                                labeltext: "Email",
                                validator: validateEmail,
                                onChange: (value) => model.emailController,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextFields(
                                controller: model.passwordController,
                                labeltext: "Password",
                                validator: validPassword,
                                inputType: null,
                                isSecure: true,
                                onChange: (value) => model.passwordController,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              CustomButton(
                                width: MediaQuery.of(context).size.width - 100,
                                title: "Login",
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    FocusScope.of(context).unfocus();

                                    model.loginUser(
                                      errorCallback: (e) {
                                        showErrorDialog(context, e);
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUpPage.id);
                    },
                    child: Text(
                      "Sign Up Here",
                      style: googleFont(),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
          isLoading: Provider.of<LoginPageModel>(context).loading,
        );
      },
    );
  }
}

class LoginPageModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool loading = false;

  String get _email => emailController.text;
  String get _password => passwordController.text;

  Future<void> loginUser({
    void Function(FirebaseAuthException e) errorCallback,
  }) async {
    var connection = await Connectivity().checkConnectivity();

    if (connection != ConnectivityResult.wifi &&
        connection != ConnectivityResult.mobile) {
      print("No Internet");
      return;
    }

    loading = true;
    notifyListeners();

    Future.delayed(
      Duration(seconds: 2),
      () async {
        try {
          UserCredential _credential = await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);

          if (_credential.user != null) {
            print("Success");
          }
        } on FirebaseAuthException catch (e) {
          errorCallback(e);
        } catch (e) {
          errorCallback(e);
        }

        loading = false;
      },
    );
  }
}
