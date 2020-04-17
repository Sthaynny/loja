import 'package:flutter/material.dart';
import 'package:loja/screens/tabs/homeTab/home_tab.dart';
import 'package:loja/screens/tabs/ordersTab/orders_tab.dart';
import 'package:loja/screens/tabs/placesTab/places_tab.dart';
import 'package:loja/screens/tabs/productsTab/pruducts_tab.dart';
import 'package:loja/screens/widgets/cart_button.dart';
import 'package:loja/screens/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          floatingActionButton: CartButton(),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          body: HomeTab(),
        ),
        Scaffold(
          floatingActionButton: CartButton(),
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          body: ProductsTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          body: PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus pedidos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          body: OrdersTab(),
        ),
      ],
    );
  }
}
