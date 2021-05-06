import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/CustomTextField.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Extension/Validations.dart';
import 'package:video_share/src/Model/FBUser.dart';
import 'package:video_share/src/Provider/UserState.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignpState');
  static const String id = "signUp";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpPageModel>(
      create: (context) => SignUpPageModel(),
      builder: (context, snapshot) {
        return OverlayLoadingWidget(
          isLoading: Provider.of<SignUpPageModel>(context).loading,
          child: Scaffold(
            backgroundColor: Colors.red[200],
            body: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        "SignUp",
                        style: googleFont(size: 25, fw: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Consumer<SignUpPageModel>(
                        builder: (context, model, child) {
                          return Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextFields(
                                    controller: model.nameTextControlller,
                                    labeltext: "Fullname",
                                    validator: valideName,
                                    onChange: (value) =>
                                        model.nameTextControlller,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
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
                                    onChange: (value) =>
                                        model.passwordController,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  CustomButton(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    title: "SIgn Up",
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        FocusScope.of(context).unfocus();
                                        model.signUpUser(
                                          onSuccess: (user) {
                                            currentUser = user;
                                            Navigator.of(context).pop();
                                          },
                                          errorCallback: (e) {
                                            print(e);
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
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Login",
                          style: googleFont(),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 5,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class SignUpPageModel extends ChangeNotifier {
  TextEditingController nameTextControlller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String get _fullname => nameTextControlller.text;
  String get _email => emailController.text;
  String get _password => passwordController.text;
  bool loading = false;

  final _auth = FirebaseAuth.instance;

  Future<void> signUpUser({
    @required void Function(FBUser user) onSuccess,
    @required void Function(FirebaseAuthException e) errorCallback,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      print("No Internet");
      return;
    }

    loading = true;
    notifyListeners();

    Future.delayed(Duration(seconds: 2));

    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      if (_credential.user != null) {
        FBUser user = FBUser(
          uid: _credential.user.uid,
          name: _fullname,
          email: _email,
        );

        firebaseRef(FirebaseRef.user).doc(user.uid).set(user.toMap());
        notifyListeners();
        onSuccess(user);
      }
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    } catch (e) {
      errorCallback(e);
    }

    loading = false;
  }
}