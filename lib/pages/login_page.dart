import 'package:flutter/material.dart';
import 'package:flutter_login_application/components/alert_dialog_comp.dart';
import 'package:flutter_login_application/components/inputForm.dart';
import 'package:flutter_login_application/services/user_services.dart';
import 'package:flutter_login_application/utils/constants.dart';
import 'package:flutter_login_application/utils/theme_color.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_account.dart';
import 'user_pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var userService = UserServices();

  signIn(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };

    var body = jsonEncode(data);
    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var response = await userService.post(
      Constants.HOST + '/login',
      body,
      Constants.CONTENT_TYPE,
    );

    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
        sharedPreferences.setString('id', jsonData['user']['id']);
        sharedPreferences.setString('token', jsonData['token']);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (route) => false);
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        child: AlertDialogComp(
          title: 'Alerta',
          child: Text('Erro ao fazer login'),
          icon: Icons.warning_outlined,
          iconColor: ThemeColor.warningColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.canvasColor[700],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white10,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  headerSection(),
                  textSection(),
                  buttonSection(),
                  forgetPasswordSection(),
                  createAccountSection()
                ],
              ),
            ),
    );
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FittedBox headerSection() {
    return FittedBox(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            '!Shopping List',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColor.canvasColor[500],
              fontSize: 40,
              fontWeight: FontWeight.bold,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                InputForm(
                  title: 'Email',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textColor: ThemeColor.canvasColor[200],
                  hintColor: ThemeColor.primaryColor,
                  iconColor: ThemeColor.canvasColor[200],
                  isPasswordType: false,
                ),
                SizedBox(height: 30),
                InputForm(
                  title: 'Password',
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  keyboardType: TextInputType.multiline,
                  textColor: ThemeColor.canvasColor[200],
                  hintColor: ThemeColor.primaryColor,
                  iconColor: ThemeColor.canvasColor[200],
                  suffixIcon: Icons.remove_red_eye_outlined,
                  isPasswordType: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buttonSection() {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: 30),
        child: RaisedButton(
          splashColor: ThemeColor.secundaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.login,
                  color: ThemeColor.secundaryColor,
                ),
              ),
              Text(
                'Entrar',
                style: TextStyle(
                  color: ThemeColor.secundaryColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: ThemeColor.primaryColor,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              setState(() {
                _isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 3000), () async {
                try {
                  await signIn(emailController.text, passwordController.text);
                } catch (e) {
                  return e.toString();
                }
              });
            }
          },
        ));
  }

  Container forgetPasswordSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: EdgeInsets.only(bottom: 20, top: 0),
      alignment: Alignment.bottomRight,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          InkWell(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    color: ThemeColor.secundaryColor,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()),
                  (route) => false);
            },
          )
        ],
      ),
    );
  }

  Container createAccountSection() {
    return Container(
      alignment: Alignment.bottomRight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Ainda não tem conta?",
            style: TextStyle(color: ThemeColor.secundaryColor),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                child: Text(
                  'Clique aqui e crie sua conta',
                  style: TextStyle(
                    color: ThemeColor.secundaryColor,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => CreateAccount()),
                  (route) => false);
            },
          )
        ],
      ),
    );
  }
}
