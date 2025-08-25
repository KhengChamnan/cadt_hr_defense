// import 'dart:core';
// import 'package:palm_ecommerce_mobile_app_2/components/bottomNavigator.dart';
// import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
// import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';
// import 'package:palm_ecommerce_mobile_app_2/utils/error_handler.dart';

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:palm_ecommerce_mobile_app_2/screens/splash/splash_screen.dart';
// import 'package:palm_ecommerce_mobile_app_2/utils/colors.dart';
// import 'package:provider/provider.dart';

// class SignInBody extends StatefulWidget {
//   const SignInBody({Key? key}) : super(key: key);

//   @override
//   State<SignInBody> createState() => _SignInBodyState();
// }

// class _SignInBodyState extends State<SignInBody> {
//   bool _hide = true;
//   bool checkRemember = false;
//   bool _isLoading = false;

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   // Future init() async {
//   //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
//   //   await authProvider.getSavedCredentials();
//   // }

//   Future<void> save() async {
//     //await init();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.saveCredentials(
//         email: _emailController.text, password: _passwordController.text);
//   }

//   Future<void> clear() async {
//     //await init();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.clearCredentials();
//   }

//   rememberMe() async {
//     if (!mounted) return;
    
//     setState(() {
//       _isLoading = true;
//     });
    
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       var myValue = await authProvider.getSavedCredentials();
      
//       if (mounted) {
//         setState(() {
//           _emailController.text = myValue['email'] ?? '';
//           _passwordController.text = myValue['password'] ?? '';
//           checkRemember = myValue['email'] != null && myValue['password'] != null;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> doLogin() async {
//     if (!mounted) return;
    
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     if (_formKey.currentState!.validate()) {
//       try {
//         await authProvider.login(
//             email: _emailController.text, password: _passwordController.text);

//         // Only save/clear credentials after successful login
//         if (authProvider.isLoggedIn) {
//           if (checkRemember) {
//             await save();
//           } else {
//             await clear();
//           }
          
//           // Navigate only after all operations are complete
//           if (mounted) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => const BottomNavBar()),
//             );
//           }
//         }
//       } catch (e) {
//         if (mounted) {
//           // Show user-friendly error message using the utility class
//           final friendlyError = ErrorHandler.getUserFriendlyErrorMessage(e);
//           ErrorHandler.showErrorDialog(context, friendlyError);
//         }
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Call rememberMe after the widget is fully initialized
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       rememberMe();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final authValue = authProvider.authState;
    
//     switch (authValue.state) {
//       case AsyncValueState.loading:
//         return const SplashScreen();
//       case AsyncValueState.error:
//         // Show login screen with error message instead of centered error
//         return _buildLoginScreen(context, authProvider, 
//           errorMessage: ErrorHandler.getUserFriendlyErrorMessage(authValue.error));
//       case AsyncValueState.success:
//         // Continue with the login screen
//         return _buildLoginScreen(context, authProvider, errorMessage: null);
//     }
//   }

//   Widget _buildLoginScreen(BuildContext context, AuthProvider authProvider, {String? errorMessage}) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Colors.blue,
//                         Colors.blueGrey,
//                         Colors.blue,
//                       ]),
//                 ),
//                 // Login Form
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                         width: MediaQuery.of(context).size.width - 30,
//                         height: 600,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(15)),
//                         ),
//                         child: Padding(
//                             padding: const EdgeInsets.all(10),
//                             child: _isLoading
//                             ? const SplashScreen()
//                             : Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const SizedBox(height: 10),
//                                 SizedBox(
//                                   height: 150,
//                                   width: 150,
//                                   child: Image.asset('assets/images/palm_logo.png'),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Form(
//                                   key: _formKey,
//                                   child: Column(
//                                     children: [
//                                       buildEmailFormField(),
//                                       const SizedBox(height: 12),
//                                       buildPasswordFormField(),
//                                       const SizedBox(height: 2),
//                                       buildForgetPass(),
//                                       const SizedBox(height: 10),
//                                       _buildSignInButton(),
//                                       if (errorMessage != null)
//                                         Padding(
//                                           padding: const EdgeInsets.only(top: 10),
//                                           child: Text(
//                                             errorMessage,
//                                             style: const TextStyle(
//                                                 color: Colors.red,
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ))),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   buildEmailFormField() {
//     return SizedBox(
//       //width: 300,
//       height: 60,
//       child: TextFormField(
//         validator: (value) {
//           if (value!.isEmpty) {
//             return 'Please enter your email';
//           }
//           return null;
//         },
//         controller: _emailController,
//         keyboardType: TextInputType.emailAddress,
//         decoration: InputDecoration(
//           suffix: IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.email, color: Colors.blueGrey)),
//           labelText: "Email Address",
//           hintText: "Enter your email",
//           border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8)),
//           ),
//         ),
//       ),
//     );
//   }

//   buildPasswordFormField() {
//     return SizedBox(
//       //width: 300,
//       height: 60,
//       child: TextFormField(
//         obscureText: _hide,
//         controller: _passwordController,
//         validator: (value) {
//           if (value!.isEmpty) {
//             return 'Please enter your password';
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           suffix: IconButton(
//             onPressed: () {
//               setState(() {
//                 _hide = !_hide;
//               });
//             },
//             icon: Icon(
//               _hide ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
//               color: Colors.blueGrey,
//             ),
//           ),
//           labelText: "Password",
//           hintText: "Enter your password",
//           border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8)),
//           ),
//         ),
//       ),
//     );
//   }

//   buildForgetPass() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 200,
//           child: CheckboxListTile(
//             controlAffinity: ListTileControlAffinity.leading,
//             value: checkRemember,
//             onChanged: (v) {
//               setState(() {
//                 checkRemember = !checkRemember;
//               });
//             },
//             contentPadding: EdgeInsets.zero,
//             title: const Text("Remember me!"),
//           ),
//         ),
//       ],
//     );
//   }

//   buildRemember() {
//     return Expanded(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 200,
//             child: CheckboxListTile(
//               controlAffinity: ListTileControlAffinity.leading,
//               value: checkRemember,
//               onChanged: (v) {
//                 setState(() {
//                   checkRemember = !checkRemember;
//                 });
//               },
//               contentPadding: EdgeInsets.zero,
//               title: const Text("Remember me!"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSignInButton() {
//     return MaterialButton(
//       onPressed: _isLoading ? null : () async {
//         setState(() {
//           _isLoading = true;
//         });
//         await doLogin();
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       },
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(25))),
//       color: Colorz.bgDeepBlue,
//       elevation: 0,
//       minWidth: MediaQuery.of(context).size.width - 40,
//       height: 50,
//       child: const Text(
//         'Login',
//         style: TextStyle(
//             fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
//       ),
//     );
//   }
// }
