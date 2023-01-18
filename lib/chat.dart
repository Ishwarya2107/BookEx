import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

late Uri url_send;

class Chatscreen extends StatefulWidget {
  const Chatscreen({Key? key}) : super(key: key);

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  late String subject;
  late String message;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final credential = ModalRoute.of(context)?.settings.arguments as Map;
    return Expanded(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'Chat',
            ),
            backgroundColor: Colors.black,
          ),
          body: Column(
            children: [
              SizedBox(
                height: h / 20,
              ),
              Text(
                'To: ${credential['email']}',
                style: TextStyle(fontFamily: 'pacifico', fontSize: 18),
              ),
              SizedBox(
                height: h / 10,
              ),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: 'Subject'),
                onChanged: (value) {
                  subject = value;
                },
              ),
              SizedBox(
                height: h / 10,
              ),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Message',
                ),
                maxLines: 5,
                onChanged: (value) {
                  message = value;
                },
              ),
              SizedBox(
                height: h / 10,
              ),
              FlatButton(
                  onPressed: () {
                    launchEmail(
                      toEmail: credential['email'],
                      Subject: subject,
                      Message: message,
                    );
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  color: Colors.black,
                  minWidth: 150.0,
                  height: 50.0,
                  child: Text(
                    'Enter',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )),
    );
  }
}

Future launchEmail(
    {required String toEmail,
    required String Subject,
    required String Message}) async {
  final url =
      'mailto:$toEmail?Subject=${Uri.encodeFull(Subject)}&body=${Uri.encodeFull(Message)}';
  url_send = Uri.parse(url);
  if (await canLaunchUrl(url_send)) {
    await launchUrl(url_send);
  }
}
