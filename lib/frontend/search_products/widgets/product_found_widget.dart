import 'package:flutter/material.dart';

import '../../../backend/data_models/product.dart';

class ProductFoundWidget extends StatefulWidget {
  final Product product;

  const ProductFoundWidget({super.key, required this.product});

  @override
  State<ProductFoundWidget> createState() => _ProductFoundWidgetState();
}

class _ProductFoundWidgetState extends State<ProductFoundWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.lightGreen,
          border: Border.all(),
        ),
      child: SizedBox(
        width: 400,
        height: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product.productName, textAlign: TextAlign.left,),
            Row(
              children: [
                Text('Protein: ${widget.product.proteins.toString()}  Fats: ${widget.product.fats.toString()}  Carbs: ${widget.product.carbs.toString()}'),
                const SizedBox(width: 100,),
                Text('kcal ${widget.product.calories.toString()}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
