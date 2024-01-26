import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/my_drawer.dart';
import 'package:the_wall/components/my_text_field.dart';
import 'package:the_wall/pages/profile_page.dart';
import 'package:the_wall/pages/wall_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currrentUser = FirebaseAuth.instance.currentUser!;

  //textController
  final textController = TextEditingController();

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //post message
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': currrentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    // clear the textfield
    setState(() {
      textController.clear();
    });
  }

  //navigation to profile page
  void goToProfilePage() {
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(
          onProfileTap: goToProfilePage,
          onSignOut: signUserOut,
        ),
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('The Wall'),
          backgroundColor: Colors.grey[900],
        ),
        body: Center(
          child: Column(
            children: [
              //the wall
              Expanded(
                  // データが変更されるたびにUIを更新
                  child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('User Posts')
                    .orderBy('TimeStamp',
                        descending: false) //'Timestamp'フィールドで昇順にソート
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // get the message
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                            message: post['Message'],
                            user: post['UserEmail'],
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ?? []));
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),

              //post message
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    //textfield
                    Expanded(
                      child: MyTextField(
                        controller: textController,
                        hintText: 'Wirte something on the wall..',
                        obscureText: false,
                      ),
                    ),

                    //post button
                    IconButton(
                        onPressed: postMessage,
                        icon: const Icon(Icons.arrow_circle_up))
                  ],
                ),
              ),

              //logged in
              Text(
                'LOGGED IN AS: ${currrentUser.email!}',
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
