import 'package:flutter/material.dart';

// import '../dummy_data.dart';
import '../widgets/meal_item.dart';
import '../models/meal.dart';

class CategoryMealScreen extends StatefulWidget {
  static const routeName = '/category-meal';
  List<Meal> _meals;
  CategoryMealScreen(this._meals);


  @override
  _CategoryMealScreenState createState() => _CategoryMealScreenState();
}

class _CategoryMealScreenState extends State<CategoryMealScreen> {
  String categoryTitle;
  String categoryId;
  // List<Meal> categoryMeal;
  bool didListBuiled = false;

  _removeMeal(String mealId) {
    setState(() {
      widget._meals.removeWhere((meal) => meal.id == mealId);
      print('meall removed');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!didListBuiled) {

      final routeParams =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeParams['title'];
      categoryId = routeParams['id'];
      widget._meals = widget._meals.where((meal) {
        return meal.categories.contains(categoryId);
      }).toList();
      didListBuiled = true;
      print('meal list generated');
    }
    print('did change called');
  }

  @override
  Widget build(BuildContext context) {
    print(widget._meals.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext ctx, index) {
          return MealItem(
            // removeItem: _removeMeal,
            id: widget._meals[index].id,
            title: widget._meals[index].title,
            affordability: widget._meals[index].affordability,
            complexity: widget._meals[index].complexity,
            duration: widget._meals[index].duration,
            imageUrl: widget._meals[index].imageUrl,
          );
          // return Text(widget._meals[index].title);
        },
        itemCount: widget._meals.length,
      ),
    );
  }
}
