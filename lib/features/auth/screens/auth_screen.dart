import 'package:flutter/material.dart';
import 'package:shop_circuit/common/widgets/custom_button.dart';
import 'package:shop_circuit/common/widgets/custom_textfield.dart';
import 'package:shop_circuit/constants/global_variables.dart';
import 'package:shop_circuit/features/auth/services/auth_service.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth? _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService authService =
      AuthService(); // instance of class AuthService

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            // to fix bottom overflowed when keyboard pops up while entering data in fields
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Create account.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tileColor: _auth == Auth.signup
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signup,
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    },
                  ),
                ),
                if (_auth == Auth.signup)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hintText: "Name",
                          ),
                         const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _emailController,
                            hintText: "Email",
                          ),
                         const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            isPassword: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            text: "Sign Up",
                            onTap: () {
                              if (_signUpFormKey.currentState!.validate()) {
                                //validate() return a boolean value
                                signUpUser();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  title: const Text(
                    'Sign-In.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tileColor: _auth == Auth.signin
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signin,
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    },
                  ),
                ),
                if (_auth == Auth.signin)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                        const  SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller:
                                _emailController, //yaha signup wala hi controller use kiya hai, kyuki maan lo Create Account wala radio button active tha aur user ne apna email aur password likh dia wahi pr, aur ekdum se usse yaad aya ki maine to Create Acoount m details bhar di, fir jab wo Sign-In wala radio button click karega to udhar uska email and password wahi likha hoga jo usne Create Account wale m daala tha kyuki same controller use kiya hai
                            hintText: "Email",
                            isPassword: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            isPassword: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            text: "Sign In",
                            onTap: () {
                              if (_signInFormKey.currentState!.validate()) {
                                //validate() return a boolean value
                                signInUser();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
