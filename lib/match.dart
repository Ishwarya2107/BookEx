import 'package:bookex/photo.dart';
import 'package:flutter/material.dart';

class Notifyscreen extends StatefulWidget {
  const Notifyscreen({Key? key}) : super(key: key);

  @override
  State<Notifyscreen> createState() => _NotifyscreenState();
}

class _NotifyscreenState extends State<Notifyscreen> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final Details = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: h / 30,
            ),
            Text(
              "It's a Match",
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'pacifico',
              ),
            ),
            SizedBox(
              height: h / 30,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Your ${Details['Title']} and ${Details['Title2']} have been liked by eachother.',
                style: TextStyle(fontFamily: 'pacifico', fontSize: 17),
              ),
            ),
            SizedBox(
              height: h / 20,
            ),
            Center(
              child: Row(
                children: [
                  SizedBox(
                    width: w / 7,
                  ),
                  //two circle gravatar to display two images of books
                  CircleAvatar(
                    backgroundImage: NetworkImage(Details['Image']),
                    radius: 50,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(Details['Image2']),
                    radius: 50,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: h / 10,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat',
                    arguments: {"email": Details['email']});
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              color: Colors.black,
              minWidth: 150.0,
              height: 50.0,
              child: Text(
                "Send message",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(
              height: h / 30,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              color: Colors.black,
              minWidth: 150.0,
              height: 50.0,
              child: Text(
                "Keep swiping",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
