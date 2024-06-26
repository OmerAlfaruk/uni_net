import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uni_link/constant/const.dart';
import 'package:uni_link/features/post/data/models/post_model.dart';
import 'package:uni_link/features/post/data/data_sources/post_remote_data_src.dart';
import 'package:uni_link/features/post/domain/entities/post_entity.dart';
import 'package:uuid/uuid.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSrc{

  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  PostRemoteDataSourceImpl( {required this.firebaseFirestore, required this.firebaseAuth,required this.firebaseStorage,});



  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection =  firebaseFirestore.collection(FirebaseConst.content).doc(FirebaseConst.posts).collection(FirebaseConst.posts);

    final newPost = PostModel(
        userProfileUrl: post.userProfileUrl,
        username: post.username,
        totalLikes: 0,
        totalComments: 0,
       postType: post.postType,
        postImageUrl: post.postImageUrl,
        postId: post.postId,
        likes: [],
        description: post.description,
        creatorUid: post.creatorUid,
        createAt: post.createAt
    ).toJson();

    try {

      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(post.creatorUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPosts');
              userCollection.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    }catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deletePost( PostEntity post) async {
    final currentUserId=firebaseAuth.currentUser!.uid;

       final postCollection =  firebaseFirestore.collection(FirebaseConst.content).doc(FirebaseConst.posts).collection(FirebaseConst.posts);

    try {

        postCollection.doc(post.postId).delete().then((value) {
          final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(post.creatorUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPosts');
              userCollection.update({"totalPosts": totalPosts - 1});
              return;
            }
          });
        });
      } catch (e) {
      print("some error occurred $e");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
       final postCollection =  firebaseFirestore.collection(FirebaseConst.content).doc(FirebaseConst.posts).collection(FirebaseConst.posts);
    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        });
      } else {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection =  firebaseFirestore.collection(FirebaseConst.content).doc(FirebaseConst.posts).collection(FirebaseConst.posts).orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection =  firebaseFirestore.collection(FirebaseConst.content).doc(FirebaseConst.posts).collection(FirebaseConst.posts).orderBy("createAt", descending: true).where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
       final postCollection =  firebaseFirestore.collection(FirebaseConst.content).doc(FirebaseConst.posts).collection(FirebaseConst.posts);
    Map<String, dynamic> postInfo = Map();

    if (post.description != "" && post.description != null) postInfo['description'] = post.description;
    if (post.postImageUrl != "" && post.postImageUrl != null) postInfo['postImageUrl'] = post.postImageUrl;

    postCollection.doc(post.postId).update(postInfo);
  }
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;
  @override
  Future<String> uploadImageToStorage(File? file, bool isPost, String childName) async {

    Reference ref = firebaseStorage.ref().child(childName).child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl = (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }
}