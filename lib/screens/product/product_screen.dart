import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja/controller/cart_controller.dart';
import 'package:loja/controller/user_controller.dart';
import 'package:loja/models/cart_products.dart';
import 'package:loja/models/products.dart';
import 'package:loja/screens/cart/cart_screen.dart';
import 'package:loja/screens/login/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  const ProductScreen({Key key, this.product}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color prymaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.image.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 6,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: prymaryColor,
              //TODO: AUTOPLAY: passa altomaticamente
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //TODO: NOME + PREÇO
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: prymaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                SizedBox(height: 16),
                //TODO: TAMANHO CAMISA
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            color: s == size ? Colors.black26 : Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            border: Border.all(
                              color:
                                  s == size ? prymaryColor : Colors.grey[500],
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                //TODO: BOTÃO
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao Carrinho"
                          : "Entre para comprar",
                      style: TextStyle(fontSize: 18),
                    ),
                    color: prymaryColor,
                    textColor: Colors.white,
                    onPressed: size != null
                        ? () {
                            if (UserModel.of(context).isLoggedIn()) {
                              //adicionar o carrinho
                              CartProduct cartProduct = CartProduct();
                              cartProduct.size = size;
                              cartProduct.quantity = 1;
                              cartProduct.pid = product.id;
                              cartProduct.category = product.category;
                              cartProduct.productData = product;

                              CartModel.of(context).addCartItem(cartProduct);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CartScreen(),
                                ),
                              );
                            } else {
                              //abrir a tela para o ussuario logar
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            }
                          }
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                //TODO: Descrição
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
