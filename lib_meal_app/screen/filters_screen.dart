import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function setFilters;
  final Map<String,bool> filters;
  FiltersScreen(this.filters,this.setFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _isGluttenFree;

  bool _vegetarian;

  bool _vegan;

  bool _lactoseFree;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isGluttenFree = widget.filters['_isGluttenFree'];
    _vegetarian = widget.filters['_vegetarian'];
    _vegan = widget.filters['_vegan'];
    _lactoseFree = widget.filters['_lactoseFree'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Screen'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save),onPressed: (){
            widget.setFilters({
               '_isGluttenFree' : _isGluttenFree,
               '_vegetarian' : _vegetarian,
               '_vegan' : _vegan,
               '_lactoseFree' : _lactoseFree,
            });
          },)
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                SwitchListTile(
                  title: Text('Glutten Free'),
                  subtitle: Text('Only Include Glutten Free Meals'),
                  value: _isGluttenFree,
                  onChanged: (newValue) {
                    setState(() {
                      _isGluttenFree = newValue;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Lactose Free'),
                  subtitle: Text('Only Include Lactose Free Meals'),
                  value: _lactoseFree,
                  onChanged: (newValue) {
                    setState(() {
                      _lactoseFree = newValue;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Vegetarian'),
                  subtitle: Text('Only Include Vegetarian Meals'),
                  value: _vegetarian,
                  onChanged: (newValue) {
                    setState(() {
                      _vegetarian = newValue;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Vegan'),
                  subtitle: Text('Only Include Vegan Meals'),
                  value: _vegan,
                  onChanged: (newValue) {
                    setState(() {
                      _vegan = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
    );
  }
}
