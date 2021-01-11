import 'package:flutter/material.dart';
import 'package:flutter_login_application/components/alert_dialog_comp.dart';
import 'package:flutter_login_application/pages/login_page.dart';
import 'package:flutter_login_application/utils/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;

  signUp(String name, String email, String password,
      String passwordConfirmation) async {
    Map data = {
      "name": name,
      "email": email,
      "password": password,
      "passwordConfirmation": passwordConfirmation,
    };

    var body = jsonEncode(data);
    print(body);
    var response = await http.post(
      Constants.HOST + '/users',
      body: body,
      headers: Constants.CONTENT_TYPE,
    );

    if (response.statusCode == 201) {
      setState(() {
        _isLoading = false;

        showDialog(
          context: context,
          child: AlertDialog(
            title: Container(
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  Text('Aviso'),
                ],
              ),
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cadastro realizado com sucesso.'),
                  SizedBox(height: 20),
                  Text('Faça o login para acessar o app...'),
                ],
              ),
            ),
            actions: [
              FlatButton(
                color: Colors.deepPurple,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (route) => false);
                },
                child: Text('Ok'),
              ),
            ],
          ),
        );
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        child: AlertDialogComp(
            title: 'Alerta', contentText: 'Erro ao fazer o cadastro.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  goBackSection(),
                ],
              ),
      ),
    );
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  Container headerSection() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Center(
        child: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 40,
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
                inputForm('Nome', Icons.person_outline, nameController),
                SizedBox(height: 10),
                inputForm('Email', Icons.email_outlined, emailController),
                SizedBox(height: 10),
                inputFormWithObscure(
                    'Password', Icons.lock_outline, passwordController,
                    suffixIcon: Icons.remove_red_eye_outlined),
                SizedBox(height: 10),
                inputFormWithObscure('Password confirmation',
                    Icons.lock_outline, passwordConfirmationController),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextFormField inputForm(String title, IconData icon, controller,
      {IconData suffixIcon}) {
    void toggleObscureText() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

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
        suffixIcon: IconButton(
          icon: Icon(
            suffixIcon,
            color: Colors.deepPurple[300],
          ),
          onPressed: () {
            toggleObscureText();
          },
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

  TextFormField inputFormWithObscure(String title, IconData icon, controller,
      {IconData suffixIcon}) {
    void toggleObscureText() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: controller,
      obscureText: _obscureText,
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
        suffixIcon: IconButton(
          icon: Icon(
            suffixIcon,
            color: Colors.deepPurple[300],
          ),
          onPressed: () {
            toggleObscureText();
          },
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
          color: Colors.white70,
        ),
        icon: Icon(
          icon,
          color: Colors.deepPurple,
        ),
        border: const OutlineInputBorder(),
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
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.deepPurple,
        ),
        border: const OutlineInputBorder(),
        hintText: title,
        hintStyle: TextStyle(color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            toggleObscureText();
          },
        ),
      ),
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value.isEmpty) {
          return 'Preencha o campo de $title.';
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
            'Sign Up',
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
                  await signUp(
                    nameController.text,
                    emailController.text,
                    passwordController.text,
                    passwordConfirmationController.text,
                  );
                } catch (e) {
                  return e.toString();
                }
              });
            }
          },
        ));
  }

  Container goBackSection() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.keyboard_arrow_left_outlined,
            color: Colors.white70,
          ),
          InkWell(
            child: Text(
              'Go back to login',
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
