import 'package:flutter/material.dart';
import 'package:notes/Authentication/signupAndLoginValidation.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget>  createState() => _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  
  bool seePassword = true;
  Icon hiddenIcon = Icon(Icons.remove_red_eye, color: Color(0xFF6034A6), size: 22);
  Icon visibleIcon = Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 22);
  Icon passordIcon = Icon(Icons.remove_red_eye, color: Color(0xFF6034A6), size: 22);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          color: Color(0xFF0F0F1E),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(child: Image.asset("Assets/notesLogo.png", height: 250, fit: BoxFit.contain,)),
                Form(
                  key: _formState,
                  child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (!RegExp(r'\w{3,}').hasMatch(value!)){
                        return "Invalid Email";
                        }
                        else{
                          return null; 
                        }
                      },
                      cursorColor: Color(0xFF6034A6),
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.person, color: Color(0xFF6034A6), size: 30,),
                        hintStyle: TextStyle(color:Color(0xFFAEAEB3)),
                        // enabled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color(0xFF6034A6)),
                          borderRadius: BorderRadius.circular(35)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color(0xFF6034A6)),
                          borderRadius: BorderRadius.circular(35)
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.circular(35)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color(0xFF6034A6)),
                          borderRadius: BorderRadius.circular(35)
                        ), 
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        // (?=.*[A-Z])       ===> should contain at least one upper case
                        // (?=.*[a-z])       ===> should contain at least one lower case
                        // (?=.*?[0-9])      ===> should contain at least one digit
                        // (?=.*?[!@#\$&*~]) ===> should contain at least one Special character
                        // .{8,}             ===> Must be at least 8 characters in length  
                        if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value!)){
                        return "Invalid Password";
                        }
                        else{
                          return null; 
                        }
                      },
                      cursorColor: Color(0xFF6034A6),
                      controller: passwordController,
                      obscureText: seePassword,
                      style: seePassword == false ? TextStyle(color: Colors.white) : TextStyle(color: Color(0xFF6034A6)),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              seePassword = !seePassword;
                              passordIcon = seePassword == true ? hiddenIcon:visibleIcon;
                            });
                          },
                          icon: passordIcon,
                        ),
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock_person, color: Color(0xFF6034A6), size: 30,),
                        hintStyle: TextStyle(color:Color(0xFFAEAEB3)),
                        // enabled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color(0xFF6034A6)),
                          borderRadius: BorderRadius.circular(35)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color(0xFF6034A6)),
                          borderRadius: BorderRadius.circular(35)
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.circular(35)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Color(0xFF6034A6)),
                          borderRadius: BorderRadius.circular(35)
                        ),
                      ),
                    ),
                  
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () async{
                          if(_formState.currentState!.validate()){
                            await SignupAndLoginValidation(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text
                              ).loginValidation();
                          }
                        },
                        child: Text("Login", style: Theme.of(context).textTheme.labelLarge),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(370, 60),
                          backgroundColor: Color(0xFF6034A6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? ", style: TextStyle(color: Colors.white, fontSize: 16)),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).pushNamed("SignUp");
                              },
                              child: Text("Sign Up Now", style: TextStyle(color: Color(0xFF6034A6), fontSize: 16, fontWeight: FontWeight.bold))
                            )
                        ],
                      ),
                    ),
                  ],
                )
              )
              ],
            ),
          ),
        )
      ),
    );
  }
}