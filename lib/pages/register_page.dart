import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/my_button.dart';
import 'package:the_wall/components/my_text_field.dart';
import 'package:the_wall/components/square_tile.dart';
import 'package:the_wall/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editnig controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign user up method
  void signUserUp() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    if (passwordController.text != confirmPasswordController.text) {
      //show error message, passwords dont match
      showErrorMessage(
          errorTitle: 'Passwords dont match!',
          errorMessage: 'Please try again!');
      return;
    }

    //try creating user
    try {
      //create the user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //after creating the user, crete a new document in cloud firestore called Users
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'username': emailController.text.split('@')[0], // initial username
        'bio': 'Empty bio', // initial empty bio
        // add any additional fields as needed
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      // //WRONG EMAIL OR PASSWORD
      showErrorMessage(
          errorTitle: e.code,
          errorMessage: 'Please enter a valid email address and password.');
      return;
    }
  }

  void showErrorMessage({errorTitle, required String errorMessage}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(errorTitle),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 25),

            //logo
            const Icon(Icons.lock, size: 50),
            const SizedBox(height: 25),

            //Let's create an account for you!
            Text('Let\'s create an account for you!',
                style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            const SizedBox(height: 25),

            //email textfield
            MyTextField(
              controller: emailController,
              obscureText: false,
              hintText: 'Email',
            ),
            const SizedBox(height: 10),

            //password textfield
            MyTextField(
              controller: passwordController,
              obscureText: true,
              hintText: 'Password',
            ),
            const SizedBox(height: 10),

            //confirm password textfield
            MyTextField(
              controller: confirmPasswordController,
              obscureText: true,
              hintText: 'Confirm Password',
            ),
            const SizedBox(height: 50),

            //sign in buttton
            MyButton(
              text: 'Sign up',
              onTap: signUserUp,
            ),
            const SizedBox(height: 50),

            //or continue with
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 0.5, color: Colors.grey[400]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.00),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 0.5, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            //google + app sign in buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //google
                SquareTile(
                  imagePath: 'lib/images/google.png',
                  onTap: () => AuthService().signInWithGoogle(),
                ),
                const SizedBox(width: 25),
                SquareTile(
                  imagePath: 'lib/images/black-apple.png',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 50),

            //Already have an account? Login NOW
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?',
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Login NOW',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ]),
        ),
      )),
    );
  }
}
