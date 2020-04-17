import 'package:flutter/material.dart';
import 'package:loja/controller/user_controller.dart';
import 'package:scoped_model/scoped_model.dart';

class SingUpScreen extends StatefulWidget {
  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Criar Conta'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
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
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 30),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: Icon(
                      Icons.person_add,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nome Completo",
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Nome invalido!";
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Endereço",
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Endereço invalido!";
                    }
                  },
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 24),
                Container(
                  height: 50,
                  child: RaisedButton(
                    child: Text(
                      "Criar Conta",
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          "name": _nameController.text,
                          'email': _emailController.text,
                          'address': _addressController.text
                        };
                        model.singUp(
                          userData: userData,
                          pass: _passController.text,
                          onSuccess: _onSucess,
                          onFail: _onFail,
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSucess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuario criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then(
      (_) {
        Navigator.of(context).pop();
      },
    );
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar usuario!"),
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
}
