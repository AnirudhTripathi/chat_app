import 'dart:async';
import 'dart:io';

import 'package:chat_app/model/model/message_model.dart';
import 'package:chat_app/model/model/user_model.dart';
import 'package:chat_app/model/services/firebase_service.dart';
import 'package:chat_app/view/chat_screen/widgets/custom_video_message.dart';
import 'package:chat_app/viewmodel/controllers/auth_controller.dart';
import 'package:chat_app/widgets/custom_text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatScreen extends StatefulWidget {
  final UserModel receiver;

  const ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthController authController = Get.find();
  List<types.Message> _messages = [];
  final _user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  late types.User receiverUser;
  StreamSubscription? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    receiverUser = types.User(id: widget.receiver.uid);
    _loadMessages();
  }

  void _loadMessages() async {
    _messagesSubscription = FirebaseFirestore.instance
        .collection('chats')
        .doc(authController.user!.uid)
        .collection('messages')
        .doc(widget.receiver.uid)
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      List<types.Message> loadedMessages = [];
      for (var doc in snapshot.docs) {
        final messageData = doc.data() as Map<String, dynamic>;
        loadedMessages.add(_mapMessageModelToTypesMessage(
            MessageModel.fromSnap(doc), messageData['type']));
      }
      setState(() {
        _messages = loadedMessages;
      });
    });
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }

  void _sendMessage(types.Message message) async {
    if (message is types.TextMessage) {
      final messageModel = MessageModel(
        senderId: authController.user!.uid,
        receiverId: widget.receiver.uid,
        message: message.text,
        type: 'text',
        timestamp: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
      );
      _sendMessageToFirebase(
          messageModel, authController.user!.uid, widget.receiver.uid);
      _sendMessageToFirebase(
          messageModel, widget.receiver.uid, authController.user!.uid);
    } else if (message is types.ImageMessage) {
      final imageUrl = await _uploadImageToStorage(message.uri);
      if (imageUrl != null) {
        final messageModel = MessageModel(
          senderId: authController.user!.uid,
          receiverId: widget.receiver.uid,
          message: imageUrl,
          type: 'image',
          timestamp: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
        );
        _sendMessageToFirebase(
            messageModel, authController.user!.uid, widget.receiver.uid);
        _sendMessageToFirebase(
            messageModel, widget.receiver.uid, authController.user!.uid);
      } else {
        print("Image upload failed");
      }
    } else if (message is types.VideoMessage) {
      final videoUrl = await _uploadVideoToStorage(message.uri);
      if (videoUrl != null) {
        final messageModel = MessageModel(
          senderId: authController.user!.uid,
          receiverId: widget.receiver.uid,
          message: videoUrl,
          type: 'video',
          timestamp: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
        );
        _sendMessageToFirebase(
            messageModel, authController.user!.uid, widget.receiver.uid);
        _sendMessageToFirebase(
            messageModel, widget.receiver.uid, authController.user!.uid);
      } else {
        print("Video upload failed");
      }
    } else {
      print('Unsupported message type: ${message.type}');
    }
  }

  Future<String?> _uploadVideoToStorage(String? videoPath) async {
    try {
      if (videoPath == null) {
        throw Exception("Video path is null");
      }

      final file = File(videoPath);

      if (!await file.exists()) {
        throw Exception("File does not exist");
      }

      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('chat_videos/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents
          .listen((firebase_storage.TaskSnapshot snapshot) {
        switch (snapshot.state) {
          case firebase_storage.TaskState.running:
            print("Upload is running");
            break;
          case firebase_storage.TaskState.paused:
            print("Upload is paused");
            break;
          case firebase_storage.TaskState.success:
            print("Upload completed successfully");
            break;
          case firebase_storage.TaskState.canceled:
            print("Upload was canceled");
            break;
          case firebase_storage.TaskState.error:
            print("Upload failed");
            break;
        }
      });

      await uploadTask.whenComplete(() => null);

      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }

  void _sendMessageToFirebase(
      MessageModel message, String user1, String user2) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(user1)
        .collection('messages')
        .doc(user2)
        .collection('chat')
        .add(message.toJson());
  }

  Future<String?> _uploadImageToStorage(String? imagePath) async {
    try {
      final file = File(imagePath!);

      if (await file.exists()) {
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('chat_images/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(file);
        await uploadTask.whenComplete(() => null);
        return await storageRef.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
    return null;
  }

  types.Message _mapMessageModelToTypesMessage(
      MessageModel messageModel, String messageType) {
    final bool isFromCurrentUser =
        messageModel.senderId == FirebaseService.firebaseAuth.currentUser!.uid;
    switch (messageType) {
      case 'text':
        return types.TextMessage(
          author: isFromCurrentUser ? _user : receiverUser,
          createdAt: messageModel.timestamp.millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: messageModel.message,
        );
      case 'image':
        return types.ImageMessage(
          author: isFromCurrentUser ? _user : receiverUser,
          createdAt: messageModel.timestamp.millisecondsSinceEpoch,
          id: const Uuid().v4(),
          uri: messageModel.message,
          size: 0,
          name: '',
        );
      case 'video':
        return types.VideoMessage(
          author: isFromCurrentUser ? _user : receiverUser,
          createdAt: messageModel.timestamp.millisecondsSinceEpoch,
          id: const Uuid().v4(),
          uri: messageModel.message,
          size: 0,
          name: 'Video',
        );
      default:
        return types.TextMessage(
          author: isFromCurrentUser ? _user : receiverUser,
          createdAt: messageModel.timestamp.millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: 'Unsupported message type',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.name),
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            radius: 10.r,
            backgroundImage: NetworkImage(widget.receiver.profilePicture),
          ),
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: (partialText) => _sendMessage(
          types.TextMessage(
            author: _user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: partialText.text,
          ),
        ),
        user: _user,
        onAttachmentPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) => SafeArea(
              child: SizedBox(
                height: 150.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final ImagePicker _picker = ImagePicker();
                          final XFile? pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 70,
                            maxWidth: 1440,
                          );
                          if (pickedFile != null) {
                            final message = types.ImageMessage(
                              author: _user,
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                              id: const Uuid().v4(),
                              uri: pickedFile.path,
                              name: pickedFile.name,
                              size: await pickedFile.length(),
                            );
                            _sendMessage(message);
                          }
                        },
                        child: Align(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            'Photo',
                            style: CustomTextStyle.bodyText1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final ImagePicker _picker = ImagePicker();
                          final XFile? pickedFile = await _picker.pickVideo(
                            source: ImageSource.gallery,
                            maxDuration: const Duration(seconds: 60),
                          );
                          if (pickedFile != null) {
                            final message = types.VideoMessage(
                              author: _user,
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                              id: const Uuid().v4(),
                              uri: pickedFile.path,
                              name: pickedFile.name,
                              size: await pickedFile.length(),
                            );
                            _sendMessage(message);
                          }
                        },
                        child: Text(
                          'Video',
                          style: CustomTextStyle.bodyText1.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onMessageTap: (context, message) async {
          if (message is types.FileMessage) {
            await OpenFilex.open(message.uri);
          }
        },
      ),
    );
  }
}
