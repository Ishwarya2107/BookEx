import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({Key? key}) : super(key: key);

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('asset/bg_01.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Register",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Source Sans Pro',
                fontSize: 24,
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: h / 30,
              ),
              Container(
                  width: w / 0.5,
                  height: h / 2.5,
                  child: Image(image: AssetImage('asset/reg_002.png'))),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: 'Enter email'),
                onChanged: (value) {
                  email = value;

                },
              ),
              SizedBox(
                height: h / 20,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: 'Enter password'),
                onChanged: (value) {
                  password = value;

                },
              ),
              SizedBox(
                height: h / 20,
              ),
              FlatButton(
                onPressed: () async {
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);

                    if (newUser != null) {
                      Navigator.pushNamed(context, '/add',
                          arguments: {'first_register': true, 'email': email});
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                color: Colors.black,
                minWidth: 150.0,
                height: 50.0,
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
