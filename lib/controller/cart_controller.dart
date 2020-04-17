import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/controller/user_controller.dart';
import 'package:loja/models/cart_products.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;
  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  void _loading() {
    isLoading = true;
    notifyListeners();
  }

  void _notLoading() {
    isLoading = false;
    notifyListeners();
  }

  //TODO: PARA Acessar de qualquer lugar do app sem precisar de ScopdModelDecent
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then(
      (doc) {
        cartProduct.cid = doc.documentID;
      },
    );
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  Future<void> _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void setCoupom(String coupomCode, int discountPercent) {
    this.couponCode = coupomCode;
    this.discountPercentage = discountPercent;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscountPrice() {
    return getProductPrice() * (discountPercentage / 100);
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    if (products.length == 0)
      return null;
    else {
      _loading();
      double productsPrice = getProductPrice();
      double discount = getDiscountPrice();
      double shipPrice = getShipPrice();
      DocumentReference refOrder =
          await Firestore.instance.collection("orders").add(
        {
          'clientId': user.firebaseUser.uid,
          "products":
              products.map((cartProduct) => cartProduct.toMap()).toList(),
          'shipPrice': shipPrice,
          'productsPrice': productsPrice,
          'discount': discount,
          'totalPrice': (productsPrice + shipPrice - discount),
          "status": 1
        },
      );

      Firestore.instance
          .collection('users')
          .document(user.firebaseUser.uid)
          .collection("orders")
          .document(refOrder.documentID)
          .setData(
        {'orderId': refOrder.documentID},
      );

      QuerySnapshot query = await Firestore.instance
          .collection('users')
          .document(user.firebaseUser.uid)
          .collection('cart')
          .getDocuments();

      for (DocumentSnapshot doc in query.documents) {
        doc.reference.delete();
      }

      products.clear();

      discount = 0;
      couponCode = null;

      _notLoading();

      return refOrder.documentID;
    }
  }
}
