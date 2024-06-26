import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? commentId;
  final String? newsId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplays;

  CommentEntity({
    this.commentId,
    this.newsId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplays,
  });

  @override
  List<Object?> get props => [
    commentId,
    newsId,
    creatorUid,
    description,
    username,
    userProfileUrl,
    createAt,
    likes,
    totalReplays,
  ];
}
