import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _screen() => [
          data_added(
            user: loggedInUser,
          ),
        ];
    final List<Widget> screens = _screen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: SizedBox(
              child: screens[currentindex],
            ))
          ],
        ),
      ),
    );
  }
}

class data_added extends StatelessWidget {
  User? user;

  var title_book;
  data_added({Key? key, required this.user}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('my-book-exchange');
  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('some error occured ${snapshot.error}');
          }

          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            List<Map> items = documents
                .map((e) => {
                      'id': e.id,
                      'title': e['title'],
                      'place': e['place'],
                      'image': e['image'],
                      'email': e['email'],
                      'note': e['note'],
                    })
                .toList();

            return Scaffold(
              body: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = items[index];

                    if (user?.email == thisItem['email']) {
                      return Container(
                        decoration: BoxDecoration(
                          //                    <-- BoxDecoration
                          border: Border(bottom: BorderSide()),
                        ),
                        child: ListTile(
                          title: Text('${thisItem['title']}'),
                          subtitle: Text('${thisItem['place']}'),
                          leading: Container(
                            width: 80,
                            height: 80,
                            child: Image.network('${thisItem['image']}'),
                          ),
                        ),
                      );
                    }
                    return Text('');
                  }),
            );
          }
          return Text('');
        });
  }
}

class content {
  final String? image;
  content({this.image});
}
