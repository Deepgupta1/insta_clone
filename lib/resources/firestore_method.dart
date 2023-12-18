import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_insta_clone/models/post.dart';
import 'package:flutter_insta_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImagetoStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);

      _firestore.collection('post').doc(postId).set(post.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  //post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilepic) async {
    String res = "Some error occured";
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        _firestore
            .collection("post")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          'profilePic': profilepic,
          'text': text,
          'name': name,
          'uid': uid,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });

        res = "Success";
      } else {
        print("text is empty");
        res = "empty text";
      }
      return res;
    } catch (err) {
      print(err.toString());
      res = err.toString();
      return res;
    }
  }

  //deleting post

  Future<String> deletePost(String postId) async {
    String res = "Some error occured";

    try {
      await _firestore.collection('post').doc(postId).delete();
    } catch (err) {
      res = err.toString();
      return res;
    }

    return res;
  }

  //follow user
  Future<String> followUser(String uid, String followId) async {
    String res = "Some error occured";
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();

      List following = (snap.data() as dynamic)!['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (err) {
      res = err.toString();
      return res;
    }
    return res;
  }

}
