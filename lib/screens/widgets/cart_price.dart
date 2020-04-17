import 'package:flutter/material.dart';
import 'package:loja/controller/cart_controller.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;

  CartPrice({@required this.buy});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            double price = model.getProductPrice();
            double discount = model.getDiscountPrice();
            double ship = model.getShipPrice();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Ressumo do pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("SubTotal"),
                    Text("R\$ ${price.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Desconto"),
                    Text(
                      "- R\$ ${discount.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Frete"),
                    Text("R\$ ${ship.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "R\$ ${(price + ship - discount).toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  height: 50,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Finalizar Compra",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    onPressed: buy,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
