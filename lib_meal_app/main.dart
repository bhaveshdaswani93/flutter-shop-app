import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './screen/category_meal_screen.dart';

import './screen/category_screen.dart';
import './screen/meal_detail_screen.dart';
import './screen/tabs_screen.dart';
import './screen/filters_screen.dart';
import './models/meal.dart';
import './dummy_data.dart';

// import './transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    '_isGluttenFree': false,
    '_vegetarian': false,
    '_vegan': false,
    '_lactoseFree': false
  };

  List<Meal> meals = DUMMY_MEALS;
  List<Meal> favouriteMeals = [];

  _toggleFav(mealId) {
    setState(() {
      final mealIndex = favouriteMeals.indexWhere((meal) {
        return meal.id == mealId;
      });
      if (mealIndex >= 0) {
        favouriteMeals.removeAt(mealIndex);
      } else {
        favouriteMeals.add(
          DUMMY_MEALS.firstWhere((meal) => meal.id == mealId),
        );
      }
    });
  }

  _isFav(mealId) {
    return favouriteMeals.any((meal) => meal.id == mealId);
  }

  _setFilter(filters) {
    setState(() {
      _filters = filters;
      print(filters);
      meals = DUMMY_MEALS.where((meal) {
        if (_filters['_isGluttenFree'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['_vegetarian'] && !meal.isVegetarian) {
          print('vegeterian false');
          return false;
        }
        if (_filters['_vegan'] && !meal.isVegan) {
          return false;
        }
        if (_filters['_lactoseFree'] && !meal.isLactoseFree) {
          return false;
        }
        return true;
      }).toList();
      print(meals.length);
    });
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   meals = DUMMY_MEALS;
  // }

  @override
  Widget build(BuildContext context) {
    print(meals.length);
    return MaterialApp(
      title: 'Expense Manager',
      home: TabsScreen(favouriteMeals),
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
            body1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            body2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            title: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
                fontSize: 21)),
      ),
      routes: {
        CategoryMealScreen.routeName: (BuildContext ctx) =>
            CategoryMealScreen(meals),
        MealDetailScreen.routeName: (BuildContext ctx) =>
            MealDetailScreen(_toggleFav, _isFav),
        FiltersScreen.routeName: (BuildContext ctx) =>
            FiltersScreen(_filters, _setFilter),
      },
      // onGenerateRoute:(_){

      //   return MaterialPageRoute(builder: (_)=>CategoryScreen());
      // } ,
      // onUnknownRoute: (_){
      //    return MaterialPageRoute(builder: (_)=>CategoryScreen());
      // },
    );
  }
}
