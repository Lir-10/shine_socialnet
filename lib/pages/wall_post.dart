import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/lile_buton.dart';
import 'package:the_wall/components/comment_button.dart';
import 'package:the_wall/components/comments.dart';
import 'package:the_wall/helper/helper_methods.dart';

import '../components/delete_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;
  final String imageURL;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
    required this.imageURL,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comment")
        .add({
      "commentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  void CommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Agrega un comentario"),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(hintText: "Escribe un comentario..... "),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addComment(commentController.text);
              Navigator.pop(context);
              commentController.clear();
            },
            child: Text("Publicar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }
  

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void deletePosts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar Publicacion"),
        content: Text("¿Estas seguro que quieres eliminar esta publicacion? "),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final commentDocs = await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comment")
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comment")
                    .doc(doc.id)
                    .delete();
              }

              FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("Publicacion eliminada"))
                  .catchError((error) => print("failed to delete post"));

              Navigator.pop(context);
            },
            child: Text("Eliminar"),
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.only(top: 25, right: 25, left: 25),
    padding: const EdgeInsets.all(25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.user == currentUser.email)
              DeleteButton(
                ontap: () {
                  deletePosts();
                },
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (widget.imageURL.isNotEmpty)
          Image.network(
            widget.imageURL,
            fit: BoxFit.cover,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              return const Text('Error loading image');
            },
          ),
        const SizedBox(height: 10),
        if (widget.message.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    " . ",
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LikeButton(
                        isLiked: isLiked,
                        onTap: toggleLike,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.likes.length.toString(),
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CommmentButton(ontap: CommentDialog),
                      const SizedBox(width: 4),
                      // Puedes usar el contador real de comentarios aquí
                      Text("0", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comment")
                    .orderBy("CommentTime", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      final commentData = doc.data() as Map<String, dynamic>;
                      return Comments(
                        text: commentData['commentText'],
                        user: commentData['CommentedBy'],
                        time: formatDate(commentData['CommentTime']),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
      ],
    ),
  );
}

}
