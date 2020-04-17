import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String orderID;

  const OrderScreen({Key key, @required this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido realizado"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80,
            ),
            Text(
              "Pedido Realizado com sucesso!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Código do pedido: ${orderID}",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
