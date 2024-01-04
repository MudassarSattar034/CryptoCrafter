import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddImagePostService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(String filePath) async {
    Reference ref = _storage
        .ref()
        .child('posts/images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = ref.putFile(File(filePath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addImagePost(String imageUrl, String caption) async {
    CollectionReference posts = _firestore.collection('posts');
    await posts.add({
      'type': 'image',
      'imageUrl': imageUrl,
      'caption': caption,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}