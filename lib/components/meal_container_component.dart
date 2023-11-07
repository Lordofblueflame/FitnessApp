import 'package:flutter/material.dart';

import '../components/buttons/add_product_button.dart';
import '../data_models/meal.dart';
import '../data_models/user.dart';
import '../views/main_aplication/search_products_view.dart';

class MealContainerComponent extends StatefulWidget {
  final Meal meal;
  final int mealKcal;
  final DateTime date;
  final User user;

  const MealContainerComponent({
    Key? key,
    required this.meal,
    required this.mealKcal,
    required this.date,
    required this.user,
  }) : super(key: key);

  @override
  _MealContainerComponentState createState() => _MealContainerComponentState();
}

class _MealContainerComponentState extends State<MealContainerComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightGreen[500],
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.elliptical(25, 10),
          right: Radius.elliptical(25, 10),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  widget.meal.mealName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                Text(
                  '${widget.mealKcal} kcal',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          AddProductButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SearchProductsView(meal: widget.meal, date: widget.date, user: widget.user),
                ),
              );
            },
            shape: BoxShape.circle,
          ),
        ],
      ),
    );
  }
}
