import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_circuit/constants/global_variables.dart';

class Stars extends StatelessWidget {
  final double rating;
  const Stars({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      itemCount: 5,
      direction: Axis.horizontal,
      itemSize: 15,
      rating: rating,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: GlobalVariables.secondaryColor,
      ),
    );
  }
}
