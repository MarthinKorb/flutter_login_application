import 'package:flutter/material.dart';
import 'package:flutter_login_application/components/alert_dialog_comp.dart';
import 'package:flutter_login_application/services/user_services.dart';
import 'package:flutter_login_application/utils/constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'create_account.dart';
import 'user_pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;

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
          ));
    }
  }

  Future<dynamic> take() async {
    var response = await http.get(Constants.HOST + '/users');
    print(response.body);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple[500],
                Colors.deepPurple[800],
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white10,
                  ),
                )
              : ListView(
                  children: [
                    headerSection(),
                    textSection(),
                    buttonSection(),
                    forgetPasswordSection(),
                    createAccountSection(),
                  ],
                ),
        ),
      ),
    );
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Container headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Center(
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 50,
          ),
        ),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                inputForm('Email', Icons.email_outlined, emailController),
                SizedBox(height: 30),
                txtPassword('Password', Icons.lock_outline),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextFormField inputForm(String title, IconData icon, controller) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: controller,
      style: TextStyle(color: Colors.white54),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(
          color: Colors.deepPurple[300],
        ),
        icon: Icon(
          icon,
          color: Colors.deepPurple[300],
        ),
        border: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return 'Preencha o campo de $title';
        }
        return null;
      },
    );
  }

  TextFormField txtEmail(String title, IconData icon) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: emailController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(
          color: Colors.deepPurple[300],
        ),
        icon: Icon(
          icon,
          color: Colors.deepPurple[300],
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return 'Preencha o campo de email.';
        }
        return null;
      },
    );
  }

  TextFormField txtPassword(String title, IconData icon) {
    void toggleObscureText() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: _obscureText,
      controller: passwordController,
      style: TextStyle(color: Colors.deepPurple[300]),
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.deepPurple[300],
        ),
        border: const OutlineInputBorder(),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.deepPurple[300]),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: Colors.deepPurple[300],
          ),
          onPressed: () {
            toggleObscureText();
          },
        ),
      ),
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value.isEmpty) {
          return 'Preencha o campo de senha.';
        }
        return null;
      },
    );
  }

  Container buttonSection() {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: 30),
        child: RaisedButton(
          splashColor: Colors.purple,
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.deepPurple,
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
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.white70,
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
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Text(
            "Don't have account? ",
            style: TextStyle(color: Colors.white70),
          ),
          InkWell(
            child: Container(
              // color: Colors.white70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple[300],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                child: Text(
                  'Create a new account',
                  style: TextStyle(
                    color: Colors.white70,
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
