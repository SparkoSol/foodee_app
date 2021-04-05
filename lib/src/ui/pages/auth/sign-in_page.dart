import 'package:dio/dio.dart';
import 'package:foodee/src/app.dart';
import 'package:foodee/src/data/data.dart';
import 'package:foodee/src/services/lazy-task_service.dart';
import 'package:foodee/src/ui/modals/information_dialog.dart';
import 'package:foodee/src/ui/pages/home_page.dart';
import 'package:openapi/openapi.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodee/src/base/nav.dart';
import 'package:foodee/src/base/keys.dart';
import 'package:foodee/src/base/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodee/src/utils/validators.dart';
import 'package:foodee/src/ui/widgets/text_field.dart';
import 'package:foodee/src/ui/views/localized_view.dart';
import 'package:foodee/src/ui/pages/auth/sign-up_page.dart';

import 'forgot-password_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //final _data = AuthRequest();
  final _key = GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;
  String _userName, _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.primaryColor, AppTheme.primaryColor],
        ),
      ),
      child: LocalizedView(
        builder: (context, lang) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Form(
              autovalidateMode: _autoValidateMode,
              key: _key,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(30, 60, 30, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // logo(imgPath: "assets/images/couple4.png"),
                    Text(
                      App.name,
                      style: GoogleFonts.pacifico(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfffcc522),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        "let's choose your match",
                        style: TextStyle(
                          fontFamily: 'QuickSand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppTextField(
                      key: Keys.signInEmail,
                      icon: UniconsLine.user,
                      placeholder: "Username",
                      validator: Validators.required,
                      onSaved: (userName) => _userName = userName,
                      keyboardType: TextInputType.text,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: AppTextField.password(
                        key: Keys.signInPassword,
                        placeholder: lang.password,
                        icon: UniconsLine.lock_open_alt,
                        validator: Validators.required,
                        onSaved: (password) => _password = password,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: TextButton(
                        key: Keys.signInButton,
                        onPressed: _signIn,
                        // onPressed:(){    AppNavigation.to(context, HomePage());},
                        style: AppTheme.primaryButtonTheme,
                        child: Text(lang.signIn.toUpperCase()),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: lang.dnt_have_acc,
                        children: [
                          TextSpan(
                            text: lang.signUpNow,
                            style: TextStyle(fontWeight: FontWeight.w900),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => AppNavigation.to(context, SignUpPage()),
                          ),
                        ],
                        style: GoogleFonts.quicksand(color: Colors.white),
                      ),
                      key: Keys.signUpText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          extendBody: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: GestureDetector(
              key: Keys.forgotPasswordButton,
              // onTap: () => AppNavigation.to(context, EditProfile()),
              onTap: () => AppNavigation.to(context, ForgotPassword()),
              child: Text(
                lang.forgotPassword,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signIn() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      final _result = await LazyTaskService.execute<Response<LoginResponse>>(
        context,
        () async {
          Login loginUser = Login(
            (login) {
              login
                ..username = _userName
                ..password = _password;
            },
          );
          return Openapi().getUsersApi().usersLoginCreate(data: loginUser);
        },
        throwError: true,
      ).catchError((e) {
        print('=== === === === === === === === ===');
        print(e);
        var errorMessage = 'No Internet Connection';
        if (e?.response?.data != null)
          errorMessage = e.response.data['message'];
        openInfoDialog(
          context: context,
          title: 'Warning',
          content: errorMessage,
        );
      });
      if (_result != null) {
        print('===Message===');
        print(_result);
        if (_result.statusCode == 200) {
          AppData().setToken(_result.data.token);
          AppData().setUserId(_result.data.userId);
          return AppNavigation.to(context, HomePage());
        }
      }
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }

  invalidUser(String message, bool isEmail) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Error',
            textAlign: TextAlign.center,
            style: GoogleFonts.pacifico(
              fontWeight: FontWeight.bold,
              color: Colors.brown,
              fontSize: 24,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.brown,
                ),
                child: Text(
                  'OK',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),
            if (isEmail) TextButton(child: Text('Resend'), onPressed: _resend),
          ],
        );
      },
    );
  }

  _resend() async {
    // Navigator.of(context).pop();
    // await performLazyTask(context, () async {
    //   await FoodeeService().resendEmail(email: _email).catchError((e) {
    //     print(e);
    //   });
    // });
  }

  Widget logo({String imgPath}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset("$imgPath"),
            width: 180,
            height: 180,
          ),
        ),
      ),
    );
  }
}
