import 'package:flutter/material.dart';
import 'package:shop_circuit/constants/global_variables.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final int maxLines;

   const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.isPassword=false,
      this.maxLines = 1})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (val) {
        //property of TextFormField widget which helps us to validate contents of the form
        if (val == null || val.isEmpty) {
          return 'Enter Your ${widget.hintText}';
        }

        return null; // returning  null if its all OK
      },
      maxLines: widget.maxLines,
      obscureText: (widget.isPassword && !_passwordVisible),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        hintText: widget.hintText,
        // creating an icon which controls to show/hide passowrd in text field
        suffixIcon: widget.isPassword == true
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  //  color: Theme.of(context).primaryColorDark,
                  color: _passwordVisible
                      ? GlobalVariables.secondaryColor
                      : Colors.grey,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(
                    () {
                      _passwordVisible = !_passwordVisible;
                    },
                  );
                },
              )
            : null,
      ),
    );
  }
}
