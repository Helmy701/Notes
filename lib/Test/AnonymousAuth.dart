import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class anonymousAuth extends StatefulWidget {
  const anonymousAuth({super.key});

  @override
  State<anonymousAuth> createState() => _anonymousAuthState();
}

class _anonymousAuthState extends State<anonymousAuth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async{
              UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
              print(userCredential.user?.uid);
            },
            child: Text("Sign in")
          ),
        ],
      ),
    );
  }
}