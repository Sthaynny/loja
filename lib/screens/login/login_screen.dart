import 'package:flutter/material.dart';
import 'package:loja/controller/user_controller.dart';
import 'package:loja/screens/singup/singUp_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: "Criar conta",
            icon: Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SingUpScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor),
                  child: Icon(
                    Icons.person,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text.isEmpty || !text.contains("@")) {
                    return "E-mail invalido!";
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Senha",
                ),
                keyboardType: TextInputType.text,
                validator: (text) {
                  if (text.isEmpty || text.length < 6) {
                    return "Senha invalido!";
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      _msgEmailInvalid();
                    } else {
                      _msgEmailValid();

                      model.recoverPass(_emailController.text);
                    }
                  },
                  child: Text(
                    "Recuperar Senha",
                    style: TextStyle(color: Colors.redAccent[500]),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 50,
                child: RaisedButton(
                  child: Text(
                    "Entrar",
                    style: TextStyle(fontSize: 18),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {}

                    model.singIn(
                      email: _emailController.text,
                      pass: _passController.text,
                      onFail: _onFail,
                      onSecess: _onSucess,
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void _onSucess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao Entrar!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then(
      (_) {
        Navigator.of(context).pop();
      },
    );
  }

  void _msgEmailInvalid() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Insira seu email para a recuperação!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _msgEmailValid() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Confira seu email!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
