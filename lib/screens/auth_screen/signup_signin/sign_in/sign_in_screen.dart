import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/auth_screen/signup_signin/sign_in/components/sign_in_body.dart';

class SignInScreen extends StatelessWidget {
  //final Function function;

  const SignInScreen({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: const SignInBody(),
      ),
    );
  }
}
