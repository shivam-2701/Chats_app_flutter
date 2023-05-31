import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final String message;
  final DateTime createdOn;
  final DateTime? readOn;
  final String senderUID;
  final String? receiverUID;
  final String? receiverName;
  final String senderName;

  Message({
    this.id,
    required this.message,
    required this.createdOn,
    required this.senderUID,
    this.receiverUID,
    this.receiverName,
    required this.senderName,
    this.readOn,
  });

  factory Message.fromJSON({required Map<String, dynamic> dataMap}) {
    return Message(
      id: dataMap["id"],
      message: dataMap["message"],
      createdOn: (dataMap["created_on"] as Timestamp).toDate(),
      readOn: (dataMap["read_on"] as Timestamp?)?.toDate(),
      receiverUID: dataMap["receiver_uid"],
      receiverName: dataMap["receiver_name"],
      senderUID: dataMap["sender_uid"],
      senderName: dataMap["sender_name"],
    );
  }

  Map<String, dynamic> get toJSON {
    return {
      "message": message,
      "created_on": Timestamp.fromDate(createdOn),
      "read_on": readOn != null ? Timestamp.fromDate(readOn!) : null,
      "sender_uid": senderUID,
      "sender_name": senderName,
      "receiver_uid": receiverUID,
      "receiver_name": receiverName,
    };
  }
}
