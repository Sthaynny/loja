import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PlaceTile(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: Image.network(
              snapshot.data['image'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  snapshot.data['address'],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  launch(
                      "https://www.google.com/maps/search/?api=1&query=${snapshot.data['lat']},${snapshot.data['long']}");
                },
                child: Text(
                  "Ver no mapa",
                  style: TextStyle(color: Colors.blue),
                ),
                textColor: Colors.blue,
                padding: EdgeInsets.zero,
              ),
              SizedBox(
                width: 16,
              ),
              FlatButton(
                onPressed: () {
                  launch("tel: ${snapshot.data['phone']}");
                },
                child: Text(
                  "Ligar",
                  style: TextStyle(color: Colors.blue),
                ),
                textColor: Colors.blue,
                padding: EdgeInsets.zero,
              ),
            ],
          )
        ],
      ),
    );
  }
}
