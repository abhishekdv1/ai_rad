import 'package:airad/pages/home_page.dart';
import 'package:airad/pages/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    if (formKey.currentState!.validate()) {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      debugPrint(userCredential.user?.email.toString());
      if (auth.currentUser != null) {
        if (context.mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'AI-RAD',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ).text.xl4.bold.white.make().shimmer(
                      primaryColor: Vx.green300, secondaryColor: Colors.white),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Login now to see what they are talking!',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 10,
                  ),
                  // Image.asset('assets/images/login.png'),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Vx.green300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Vx.green300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Vx.green300),
                      ),
                      labelText: 'Email',
                      labelStyle:
                          const TextStyle(fontSize: 16, color: Vx.green300),
                      prefixIcon: const Icon(
                        Icons.email_rounded,
                        color: Vx.green300,
                      ),
                    ),
                    validator: (value) =>
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!)
                            ? null
                            : 'Please enter a valid email address',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Vx.green300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Vx.green300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Vx.green300),
                      ),
                      labelText: 'Password',
                      labelStyle:
                          const TextStyle(fontSize: 16, color: Vx.green300),
                      prefixIcon: const Icon(
                        Icons.lock_rounded,
                        color: Vx.green300,
                      ),
                    ),
                    validator: ((value) {
                      if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Vx.green300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Text.rich(TextSpan(
                    text: "Don't have an account yet?",
                    style: const TextStyle(
                      color: Vx.green300,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Register here',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Vx.green300,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ));
                            }),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
