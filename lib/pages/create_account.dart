import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_login_application/components/alert_dialog_comp.dart';
import 'package:flutter_login_application/components/inputForm.dart';
import 'package:flutter_login_application/pages/login_page.dart';
import 'package:flutter_login_application/utils/constants.dart';
import 'package:flutter_login_application/utils/theme_color.dart';
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
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      passwordConfirmationController.clear();
      showDialog(
        context: context,
        child: AlertDialogComp(
          icon: Icons.done_all_outlined,
          iconColor: ThemeColor.successColor,
          title: 'Aviso',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cadastro realizado com sucesso.'),
              SizedBox(height: 20),
              Text('Faça o login para acessar o app...'),
            ],
          ),
          pageToRedirect: LoginPage(),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        child: AlertDialogComp(
          title: 'Alerta',
          child: Text('Erro ao fazer o cadastro.'),
          icon: Icons.warning,
          iconColor: ThemeColor.warningColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.canvasColor[700],
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 30),
        child: _isLoading
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: ThemeColor.canvasColor[200],
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
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
      padding: EdgeInsets.only(top: 120),
      child: Center(
        child: Text(
          'Create Account',
          style: TextStyle(
            color: ThemeColor.canvasColor[500],
            fontSize: 40,
            fontWeight: FontWeight.bold,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                InputForm(
                  title: 'Nome',
                  icon: Icons.person_outline,
                  controller: nameController,
                  textColor: ThemeColor.canvasColor[200],
                  hintColor: ThemeColor.primaryColor,
                  iconColor: ThemeColor.canvasColor[200],
                  isPasswordType: false,
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                InputForm(
                  title: 'Senha',
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  suffixIcon: Icons.remove_red_eye_outlined,
                  textColor: ThemeColor.canvasColor[200],
                  hintColor: ThemeColor.primaryColor,
                  iconColor: ThemeColor.canvasColor[200],
                  isPasswordType: true,
                ),
                SizedBox(height: 10),
                InputForm(
                  title: 'Confirmação de senha',
                  icon: Icons.lock_outline,
                  controller: passwordConfirmationController,
                  textColor: ThemeColor.canvasColor[200],
                  hintColor: ThemeColor.primaryColor,
                  iconColor: ThemeColor.canvasColor[200],
                  isPasswordType: true,
                  suffixIcon: Icons.remove_red_eye_outlined,
                ),
              ],
            ),
          )
        ],
      ),
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

  Container buttonSection() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: 30, bottom: 50),
        child: RaisedButton(
          splashColor: ThemeColor.canvasColor[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login,
                color: ThemeColor.secundaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Finalizar Cadastro',
                  style: TextStyle(
                    color: ThemeColor.secundaryColor,
                  ),
                ),
              ),
            ],
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
      padding: EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.keyboard_arrow_left_outlined,
            color: ThemeColor.secundaryColor,
          ),
          InkWell(
            child: Text(
              'Voltar para login',
              style: TextStyle(
                color: ThemeColor.secundaryColor,
                fontSize: 16,
              ),
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
