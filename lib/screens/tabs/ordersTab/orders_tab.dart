import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/controller/user_controller.dart';
import 'package:loja/screens/login/login_screen.dart';
import 'package:loja/screens/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uId = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("users")
            .document(uId)
            .collection("orders")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.documents
                  .map(
                    (doc) => OrderTile(doc.documentID),
                  )
                  .toList()
                  .reversed
                  .toList(),
            );
          }
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.view_list,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Faça o login para acompanhar",
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
    }
  }
}
