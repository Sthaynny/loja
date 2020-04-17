import 'package:flutter/material.dart';
import 'package:loja/controller/cart_controller.dart';
import 'package:loja/controller/user_controller.dart';
import 'package:loja/screens/login/login_screen.dart';
import 'package:loja/screens/orders/orders_screen.dart';
import 'package:loja/screens/tiles/cart_tile.dart';
import 'package:loja/screens/widgets/cart_price.dart';
import 'package:loja/screens/widgets/discount_card.dart';
import 'package:loja/screens/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Meu carrinho"),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;
                return Text(
                  "${p ?? 0} ${p == 1 ? 'ITEM' : 'ITENS'}",
                  style: TextStyle(fontSize: 17),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          //TODO: AS INFORMAÇÕES ESTÃO CARREGANDO
          if (model.isLoading && UserModel.of(context).isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );

            //TODO: USUARIO NÃO ESTA LOGADO
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Faça o login para adicionar produtos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 50,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );

            //TODO: CARRIHNO VAZIO
          } else if (model.products == null || model.products.length == 0) {
            return Center(
              child: Text(
                "Nenhum produto no carrinho!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
            //TODO: CARREGAR AS INFOMAÇÕES DO CARRINHO
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((product) {
                    return CartTile(product);
                  }).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(
                  buy: () async {
                    String orderId = await model.finishOrder();
                    if (orderId != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderScreen(orderID: orderId),
                        ),
                      );
                    }
                  },
                )
              ],
            );
          }
        },
      ),
    );
  }
}
