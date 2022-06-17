import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color; // since primary color  can be NULL in ElevatedButton.styleFrom, therefore we have made it to be nullable property so that we are not required to pass any color color if we want the the button color to be in correspondence with the app theme
  const CustomButton(
      {Key? key, required this.text, required this.onTap, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(color: color == null ? Colors.white : Colors.black),
      ),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary:
            color, // if u dont specify anything, primaryColor will be null and it will default  to the theme of the applicaction
        minimumSize: const Size(double.infinity, 50), //(width,height)
      ),
    );
  }
}
