import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String senderId;
  String receiverId;
  String message;
  String type; // 'text', 'image', 'video'
  DateTime timestamp;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  // Convert to/from Firebase document 
  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "type": type,
        "timestamp": timestamp.toUtc().toString(),
      };

  static MessageModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MessageModel(
      senderId: snapshot["senderId"],
      receiverId: snapshot["receiverId"],
      message: snapshot["message"],
      type: snapshot["type"],
      timestamp: DateTime.parse(snapshot["timestamp"]),
    );
  }
}