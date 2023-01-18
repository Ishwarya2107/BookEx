import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

//--------------------------------------------------------------------------------
var title1 = '';
var email_opposite = '';
var image_opposite = '';


class MainFrontEnd extends StatefulWidget {
  const MainFrontEnd({Key? key}) : super(key: key);

  @override
  State<MainFrontEnd> createState() => _MainFrontEndState();
}

class _MainFrontEndState extends State<MainFrontEnd> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black87, Colors.white54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hi Reader',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              ListTile(
                  leading: Icon(Icons.camera_alt_rounded),
                  title: Text('Add'),
                  onTap: () {
                    Navigator.pushNamed(context, '/add',
                        arguments: {'first_register': false});
                  }),
              Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.face_retouching_natural_outlined),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/profile',
                    arguments: {
                      'swipedright': false,
                    },
                  );
                },
              ),
              Divider(
                thickness: 1,
              ),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, '/login');
                  }),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                child: displayscreen(
                  user: loggedInUser,
                ),
              ))
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class displayscreen extends StatelessWidget {
  User? user;
  displayscreen({Key? key, required this.user}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('my-book-exchange');
  late Stream<QuerySnapshot> _stream;

  MatchEngine? _matchEngine;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('some error occured ${snapshot.error}');
          }

          if (snapshot.hasData) {

            List<SwipeItem> _swipeItems = <SwipeItem>[];
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
            print(items);
            Map my_images = {};
            for(int i=0;i<items.length;i++){
              if(items[i]['email']==user?.email){
                my_images[items[i]['title']]=items[i]['image'];
              }
            }
            print(my_images);
            for (int i = 0; i < items.length; i++) {
              _swipeItems.add(
                SwipeItem(
                    content: content(image: 'image'),
                    likeAction: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(child: CircularProgressIndicator());
                          });
                      String my_book = title1;
                      String my_email = email_opposite;
                      String my_image = image_opposite;
                      Future<void> getdata() async {
                        CollectionReference _reference =
                            FirebaseFirestore.instance.collection('exchange');

                        DocumentSnapshot snapshot =
                            await _reference.doc(email_opposite).get();
                        var data = snapshot.data() as Map;
                        var liked_books = [];

                        var booksdata = data['book_id'];

                        var inside_book = booksdata[my_book] as List;

                        if (inside_book.contains(user?.email) == true) {
                          DocumentSnapshot snapshot =
                              await _reference.doc(user?.email).get();
                          var data = snapshot.data() as Map;

                          var booksdata = data['book_id'] as Map;

                          booksdata.forEach(
                            (key, value) => {
                              if (value.contains(my_email))
                                {
                                  liked_books.add(key),
                                }
                            },
                          );
                          if(liked_books.isEmpty){Navigator.pop(context);}
                          if (liked_books.isNotEmpty) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'These are the books of yours liked by this reader.Which one would you like to exchange?',
                                    style: TextStyle(
                                        fontSize: 17, fontFamily: 'pacifico'),
                                  ),
                                  content: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),

                                      for (var i in liked_books)

                                        TextButton(
                                            onPressed: () {

                                              Navigator.pushNamed(
                                                  context, '/match',
                                                  arguments: {
                                                    "Title": i,
                                                    "Image": my_images[i],
                                                    'Title2': my_book,
                                                    "Image2": my_image,
                                                    'email': my_email,
                                                  });
                                            },
                                            child: Text('${i}'))
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                        if (inside_book.contains(user?.email) == false) {

                          var mail = user?.email;
                          var my_book = title1;
                          String my_email = email_opposite;
                          var my_image = image_opposite;
                          _reference.doc(my_email).update({
                            'book_id.${my_book}': FieldValue.arrayUnion([mail])
                          });
                          DocumentSnapshot snapshot =
                              await _reference.doc(user?.email).get();
                          var data = snapshot.data() as Map;

                          var booksdata = data['book_id'] as Map;
                          var emails = my_email;
                          booksdata.forEach(
                            (key, value) => {
                              if (value.contains(my_email))
                                {
                                  liked_books.add(key),
                                }
                            },
                          );
                          if (liked_books.isEmpty){Navigator.pop(context);}
                          if (liked_books.isNotEmpty) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'These are the books of yours liked by this reader.Which one would you like to exchange?',
                                    style: TextStyle(
                                        fontSize: 17, fontFamily: 'pacifico'),
                                  ),
                                  content: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      for (var i in liked_books)
                                        TextButton(
                                            onPressed: () {



                                              Navigator.pushNamed(
                                                  context, '/match',
                                                  arguments: {
                                                    "Title": i,
                                                    "Image": my_images[i],
                                                    'Title2': my_book,
                                                    "Image2": my_image,
                                                    'email': my_email
                                                  });
                                            },
                                            child: Text('${i}'))
                                    ],
                                  ),

                                );

                              },
                            );
                          }

//end

                        }
                        ;
                      }

                      getdata();
                    }),
              );
            }

            _matchEngine = MatchEngine(
              swipeItems: _swipeItems,
            );

            return SwipeCards(
              key: key,
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                Map thisItem = items[index];

                if (user?.email != thisItem['email']) {
                  title1 = thisItem['title'];

                  email_opposite = thisItem['email'];
                  image_opposite = thisItem['image'];
                  return Stack(
                    children: <Widget>[
                      Container(
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [Colors.transparent, Colors.grey],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                            ),
                            child: Column(
                              children: [
                                Spacer(),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      thisItem['title'],
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      thisItem['place'],
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      thisItem['note'],
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            )),
                        // width: 700,
                        // height: 700,
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  CachedNetworkImageProvider(thisItem['image']),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    ],
                  );
                }

                return Text('');
              },
              onStackFinished: () {
                return ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Finished')));
              },
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
