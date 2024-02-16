import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/my_text_box.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // user
    final currentUser = FirebaseAuth.instance.currentUser!;

    //all users
    final usersCollection = FirebaseFirestore.instance.collection('Users');

    // editField
    Future<void> editField(String field) async {
      String newValue = '';
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Editar $field',
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Ingresar Nuevo $field',
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            //cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),

            //save button
            TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      //update in firestore
      if (newValue.trim().length > 0) {
        //only update if there is something in the textfield
        await usersCollection.doc(currentUser.email).update({field: newValue});
      }
    }

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Perfil de Usuario'),
          backgroundColor: Colors.grey[900],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            //get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  //profile pic
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),

                  //user email
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 50),

                  //user details
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text('My Details',
                        style: TextStyle(
                          color: Colors.grey[600],
                        )),
                  ),

                  //username
                  MyTextBox(
                    text: userData['username'],
                    sectionName: 'userName',
                    onPressed: () => editField('username'),
                  ),

                  //bio
                  MyTextBox(
                    text: userData['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),
                  const SizedBox(height: 30.0),

                  //user posts
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text('My Posts',
                        style: TextStyle(
                          color: Colors.grey[600],
                        )),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
