
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

const post = {
  "name": "Onat Çipli",
  "description": "Lorempisum",
  "profileImageUrl": "https://picsum.photos/id/241/500/500",
  "postImageUrl": "https://picsum.photos/id/200/500/500",
  "likes": ["my_current_uid"],
  "likeCount": 1,
};

PostModel postModelFromSnapshot(DocumentSnapshot snapshot) =>
    PostModel.fromSnapshot(snapshot);

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  String name;
  String description;
  String profileImageUrl;
  String postImageUrl;
  List<String> likes;
  int likeCount;
  DocumentReference reference;

  PostModel({
    this.name,
    this.description,
    this.profileImageUrl,
    this.postImageUrl,
    this.likes,
    this.likeCount,
    this.reference,
  });

  factory PostModel.fromSnapshot(DocumentSnapshot snapshot) => PostModel(
    reference: snapshot.reference,
    name: snapshot.data["name"],
    description: snapshot.data["description"],
    profileImageUrl: snapshot.data["profileImageUrl"],
    postImageUrl: snapshot.data["postImageUrl"],
    likes: List<String>.from(snapshot.data["likes"].map((x) => x)),
    likeCount: snapshot.data["likeCount"],
  );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    name: json["name"],
    description: json["description"],
    profileImageUrl: json["profileImageUrl"],
    postImageUrl: json["postImageUrl"],
    likes: List<String>.from(json["likes"].map((x) => x)),
    likeCount: json["likeCount"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "profileImageUrl": profileImageUrl,
    "postImageUrl": postImageUrl,
    "likes": List<dynamic>.from(likes.map((x) => x)),
    "likeCount": likeCount,
  };
}
