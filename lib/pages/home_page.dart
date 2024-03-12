import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/my_drawer.dart';
import 'package:the_wall/components/my_text_field.dart';
import 'package:the_wall/pages/profile_page.dart';
import 'package:the_wall/pages/wall_post.dart';
import 'package:the_wall/helper/helper_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  PickedFile? _pickedImage;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Widget _buildImagePreview() {
    if (_pickedImage != null) {
      return Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _pickedImage!.path.startsWith('http')
                  ? Image.network(
                      _pickedImage!.path,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(_pickedImage!.path),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _pickedImage = null;
                });
              },
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Future<String> _uploadImageToStorage() async {
    if (_pickedImage == null) {
      return '';
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.png');
      if (_pickedImage!.path.startsWith('http')) {
        return _pickedImage!.path;
      } else {
        await storageRef.putFile(File(_pickedImage!.path));
        return await storageRef.getDownloadURL();
      }
    } catch (e) {
      print('Error al subir la imagen: $e');
      return '';
    }
  }

  void postMessage() async {
    if (textController.text.isNotEmpty || _pickedImage != null) {
      String imageUrl = await _uploadImageToStorage();

      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'ImageURL': imageUrl,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });

      setState(() {
        textController.clear();
        _pickedImage = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = PickedFile(pickedImage.path);
      });
    }
  }

  void goToProfilePage() {
    Navigator.pop(context);
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Shine'),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Center(
        child: Column(
          children: [
            _buildImagePreview(),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('User Posts')
                    .orderBy('TimeStamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          imageURL: post['ImageURL'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Escribe Algo',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),
            Text(
              'Sesión Iniciada Como: ${currentUser.email!}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

