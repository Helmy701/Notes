import 'package:flutter/material.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF0F0F1E),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset("Assets/notesLogo.png",
                    height: 250, fit: BoxFit.contain)),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "Login");
                },
                child: Text("Login",
                    style: Theme.of(context).textTheme.labelLarge),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(370, 60),
                    backgroundColor: Color(0xFF6034A6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "SignUp");
                },
                child: Text("Sign Up",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(370, 60),
                    backgroundColor: Color(0xFF0F0F1E),
                    foregroundColor: Color(0xFF6034A6),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color(0xFF6034A6),
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignInside),
                        borderRadius: BorderRadius.circular(60))),
              ),
            )
          ],
        ));
  }
}
