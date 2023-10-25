import '../data_models/product.dart';
import 'package:flutter/material.dart';

class ProductFoundComponent extends StatefulWidget {
  final Product product;

  const ProductFoundComponent({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductFoundComponent> createState() => _ProductFoundComponentState();
}

class _ProductFoundComponentState extends State<ProductFoundComponent> {
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
