import 'package:flutter/material.dart';
import 'package:loja/controller/user_controller.dart';
import 'package:loja/screens/login/login_screen.dart';
import 'package:loja/screens/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  const CustomDrawer({Key key, this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(5, 4, 125, 141)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(
              left: 32,
              top: 16,
            ),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "Lojas \nFlutter",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData['name']}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn()
                                      ? "Entre ou cadastre-se >"
                                      : "Sair",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  !model.isLoggedIn()
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        )
                                      : model.singOut();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(
                icon: Icons.home,
                text: "Inicio",
                pageController: pageController,
                page: 0,
              ),
              DrawerTile(
                icon: Icons.list,
                text: "Produtos",
                pageController: pageController,
                page: 1,
              ),
              DrawerTile(
                icon: Icons.location_on,
                text: "Lojas",
                pageController: pageController,
                page: 2,
              ),
              DrawerTile(
                icon: Icons.playlist_add_check,
                text: "Meus Pedidos",
                pageController: pageController,
                page: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
