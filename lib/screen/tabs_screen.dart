import 'package:flutter/material.dart';

import './category_screen.dart';
import './favourite_screen.dart';
import '../widgets/main_drawer.dart';

import '../models/meal.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favouriteMeals;

  TabsScreen(this.favouriteMeals);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _pages;

  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = [
      {'page': CategoryScreen(), 'title': 'Categories'},
      {'page': FavouriteScreen(widget.favouriteMeals), 'title': 'Favourites'}
    ];
  }

  void _changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[selectedIndex]['title']),
      ),
      drawer: MainDrawer(),
      body: _pages[selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changeTab,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Favourite'),
          )
        ],
      ),
    );
  }
}
