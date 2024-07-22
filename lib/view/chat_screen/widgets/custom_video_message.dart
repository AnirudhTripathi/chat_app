import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:video_player/video_player.dart';

class CustomVideoMessage extends StatefulWidget {
  final types.VideoMessage message;

  const CustomVideoMessage({Key? key, required this.message}) : super(key: key);

  @override
  _CustomVideoMessageState createState() => _CustomVideoMessageState();
}

class _CustomVideoMessageState extends State<CustomVideoMessage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.message.uri)
      ..initialize().then((_) {
        setState(() {}); // Update the UI when the video is ready to play
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
              // Text(widget.message.timestamp.toString()), // Display timestamp or other info if needed
            ],
          ),
        ],
      ),
    );
  }
}
