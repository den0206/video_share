import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/CircleButtons.dart';
import 'package:video_share/src/Extension/CustomTextField.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Extension/StrogageRef.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Extension/Validations.dart';
import 'package:video_share/src/Model/FBUser.dart';
import 'package:video_share/src/Pages/HomePage.dart';
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
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    model.userImage == null
                                        ? CircleIconButton(
                                            onPress: model.selectImage,
                                          )
                                        : CircleImageButton(
                                            imageProvider:
                                                FileImage(model.userImage),
                                            onTap: model.selectImage,
                                          ),
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
                                      onChange: (value) =>
                                          model.emailController,
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
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      title: "SIgn Up",
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          FocusScope.of(context).unfocus();
                                          model.signUpUser(
                                            onSuccess: (user) {
                                              currentUser = user;

                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      HomePage.id);
                                              // Navigator.of(context).pop();
                                            },
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
  File userImage;
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
    @required void Function(Exception e) errorCallback,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      Exception error = Exception("No InterNet");
      errorCallback(error);
      return;
    }

    if (userImage == null) {
      Exception error = Exception("No Image");
      errorCallback(error);
      return;
    }
    isSignIn = true;
    loading = true;
    notifyListeners();

    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      if (_credential.user != null) {
        final _uid = _credential.user.uid;

        String imageUrl = await uploadStorage(
          StorageRef.profile,
          "$_uid",
          userImage,
          UploadType.image,
        );

        FBUser user = FBUser(
          uid: _uid,
          name: _fullname,
          email: _email,
          imageUrl: imageUrl,
        );

        firebaseRef(FirebaseRef.user)
            .doc(user.uid)
            .set(user.toMap())
            .then((value) {
          onSuccess(user);
        });
      }
    } on FirebaseAuthException catch (e) {
      loading = false;
      notifyListeners();
      errorCallback(e);
    } catch (e) {
      errorCallback(e);
    }

    loading = false;
  }

  Future selectImage() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        selectedAssets: resultList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      var path2 = await FlutterAbsolutePath.getAbsolutePath(
          resultList.first.identifier);
      final file = await getImageFileFromAssets(path2);
      userImage = file;
      notifyListeners();
    } on Exception catch (e) {
      print(e.toString());
    }

    /// M1 chip bug
    // final videoPath = await ImagePicker().getImage(source: ImageSource.gallery);
    // if (videoPath != null) userImage = File(videoPath.path);
    // notifyListeners();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final file = File(path);
    return file;
  }
}
