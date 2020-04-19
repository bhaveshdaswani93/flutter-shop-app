import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class FavouriteScreen extends StatelessWidget {

  List<Meal> favouriteMeals;

  FavouriteScreen(this.favouriteMeals);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext ctx, index) {
          return MealItem(
            // removeItem: _removeMeal,
            id: favouriteMeals[index].id,
            title: favouriteMeals[index].title,
            affordability: favouriteMeals[index].affordability,
            complexity: favouriteMeals[index].complexity,
            duration: favouriteMeals[index].duration,
            imageUrl: favouriteMeals[index].imageUrl,
          );
          // return Text(favouriteMeals[index].title);
        },
        itemCount: favouriteMeals.length,
      );
    
  }
}
