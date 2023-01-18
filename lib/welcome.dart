import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override

  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("asset/bg_01.png"),
          fit: BoxFit.cover,
        )),
        child: Expanded(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: h / 50,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: w / 50,
                          ),
                          Text(
                            "BookEx",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Sours Sans Pro',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h / 40,
                      ),
                      Container(
                        width: w / 0.5,
                        height: h / 2.5,
                        child: Image(
                          image: AssetImage("asset/bookx_001.png"),
                        ),
                      ),
                      SizedBox(
                        height: h / 60,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: w / 60, right: w / 60),
                        child: Text(
                          'Exchange your books',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sours Sans Pro',
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: h / 60,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: w / 50, right: w / 50),
                        child: Text(
                          ' with exciting people for',
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'Sours Sans Pro',
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: w / 50, right: w / 50),
                        child: Text(
                          ' free!',
                          style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'Sours Sans Pro',
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: h / 60,
                      ),
                      FlatButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, '/login');
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: Colors.black,
                        minWidth: 150.0,
                        height: 50.0,
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: h / 90,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: w / 5,
                          ),
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontFamily: 'Source Sans Pro',
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Register'))
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
