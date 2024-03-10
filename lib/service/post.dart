import 'dart:convert';

class ForYouPost {
  final Post post;
  final bool currentUserFollowing;
  final bool currentUserLikedPost;
  final bool isPromoterPost;

  ForYouPost({
    required this.post,
    required this.currentUserFollowing,
    required this.currentUserLikedPost,
    required this.isPromoterPost,
  });

  factory ForYouPost.fromRawJson(String str) =>
      ForYouPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForYouPost.fromJson(Map<String, dynamic> json) => ForYouPost(
        post: Post.fromJson(json["post"]),
        currentUserFollowing: json["currentUserFollowing"],
        currentUserLikedPost: json["currentUserLikedPost"],
        isPromoterPost: json["isPromoterPost"],
      );

  Map<String, dynamic> toJson() => {
        "post": post.toJson(),
        "currentUserFollowing": currentUserFollowing,
        "currentUserLikedPost": currentUserLikedPost,
        "isPromoterPost": isPromoterPost,
      };
}

class Post {
  final String id;
  final String postUserId;
  final String postType;
  final String postPrivacy;
  final String caption;
  final List<String> media;
  final bool isPublicDm;
  final DateTime postedAt;
  final dynamic editedAt;
  final int likes;
  final int viewCount;
  final int shareCount;
  final dynamic country;
  final dynamic state;
  final dynamic ipAddress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic sourceUserId;
  final dynamic userId;
  final String commentCount;
  final String likesCount;
  final Posts posts;
  final List<PostLike> postLikes;
  final dynamic originalAuthor;

  Post({
    required this.id,
    required this.postUserId,
    required this.postType,
    required this.postPrivacy,
    required this.caption,
    required this.media,
    required this.isPublicDm,
    required this.postedAt,
    required this.editedAt,
    required this.likes,
    required this.viewCount,
    required this.shareCount,
    required this.country,
    required this.state,
    required this.ipAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.sourceUserId,
    required this.userId,
    required this.commentCount,
    required this.likesCount,
    required this.posts,
    required this.postLikes,
    required this.originalAuthor,
  });

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        postUserId: json["user_id"],
        postType: json["postType"],
        postPrivacy: json["postPrivacy"],
        caption: json["caption"],
        media: List<String>.from(json["media"].map((x) => x)),
        isPublicDm: json["isPublicDm"],
        postedAt: DateTime.parse(json["postedAt"]),
        editedAt: json["editedAt"],
        likes: json["likes"],
        viewCount: json["viewCount"],
        shareCount: json["shareCount"],
        country: json["country"],
        state: json["state"],
        ipAddress: json["ip_address"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        sourceUserId: json["source_user_id"],
        userId: json["userId"],
        commentCount: json["commentCount"],
        likesCount: json["likesCount"],
        posts: Posts.fromJson(json["posts"]),
        postLikes: List<PostLike>.from(
            json["postLikes"].map((x) => PostLike.fromJson(x))),
        originalAuthor: json["originalAuthor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": postUserId,
        "postType": postType,
        "postPrivacy": postPrivacy,
        "caption": caption,
        "media": List<dynamic>.from(media.map((x) => x)),
        "isPublicDm": isPublicDm,
        "postedAt": postedAt.toIso8601String(),
        "editedAt": editedAt,
        "likes": likes,
        "viewCount": viewCount,
        "shareCount": shareCount,
        "country": country,
        "state": state,
        "ip_address": ipAddress,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "source_user_id": sourceUserId,
        "userId": userId,
        "commentCount": commentCount,
        "likesCount": likesCount,
        "posts": posts.toJson(),
        "postLikes": List<dynamic>.from(postLikes.map((x) => x.toJson())),
        "originalAuthor": originalAuthor,
      };
}

class PostLike {
  final String userId;

  PostLike({
    required this.userId,
  });

  factory PostLike.fromRawJson(String str) =>
      PostLike.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostLike.fromJson(Map<String, dynamic> json) => PostLike(
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
      };
}

class Posts {
  final String userId;
  final bool verificationStatus;
  final String? profilePhoto;
  final String username;
  final String fullName;

  Posts({
    required this.userId,
    required this.verificationStatus,
    required this.profilePhoto,
    required this.username,
    required this.fullName,
  });

  factory Posts.fromRawJson(String str) => Posts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        userId: json["user_id"],
        verificationStatus: json["verificationStatus"],
        profilePhoto: json["profilePhoto"],
        username: json["username"],
        fullName: json["fullName"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "verificationStatus": verificationStatus,
        "profilePhoto": profilePhoto,
        "username": username,
        "fullName": fullName,
      };
}
