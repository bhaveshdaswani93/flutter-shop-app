import 'package:flutter/material.dart';

import '../screen/category_meal_screen.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final Color color;

  CategoryItem({this.id,this.title, this.color});

  navigateToReceipe(BuildContext context) {
    Navigator.of(context).pushNamed(CategoryMealScreen.routeName,arguments: {
      'id':id,
      'title':title
    });
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (BuildContext ctx) {
    //     return CategoryMealScreen(this.id,this.title);
    //   }),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>navigateToReceipe(context),
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            title,
            style: Theme.of(context).textTheme.title,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          )),
    );
  }
}
