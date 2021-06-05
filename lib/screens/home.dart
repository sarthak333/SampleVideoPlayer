import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:yellow_class/cubits/auth.dart';

const double cPreviewHeight = 100;
const double cPreviewWidth = 150;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthCubit _authCubit = AuthCubit();
  late VideoPlayerController _videoController;
  late CameraController _cameraController;
  late List<CameraDescription> cameras = [];
  double volume = 0.1;

  double? dx;
  double? dy;
  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/vid.mp4')
      ..initialize().then((_) {
        _videoController.play();
        setState(() {});
      });
    _handleCameraInit();
  }

  Future<void> _handleCameraInit() async {
    cameras = await availableCameras();
    CameraDescription selectedCamera;
    selectedCamera =
        cameras.isNotEmpty && cameras.length > 1 ? cameras[1] : cameras[0];
    if (cameras.isNotEmpty) {
      _cameraController =
          CameraController(selectedCamera, ResolutionPreset.max);
      _cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  void _handleVolumeChange(double nextVolume) {
    _videoController.setVolume(nextVolume);
    setState(() {
      volume = nextVolume;
    });
  }

  void _handleDragEnd(details) {
    double safeWidthMax = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double safeWidthMin = MediaQuery.of(context).padding.top;

    setState(() {
      dx = details.offset.dx > safeWidthMin &&
              details.offset.dx < (safeWidthMax - cPreviewWidth)
          ? details.offset.dx
          : details.offset.dx < 0
              ? safeWidthMin
              : safeWidthMax - cPreviewWidth;
      dy = details.offset.dy > 0 &&
              details.offset.dy <
                  (MediaQuery.of(context).size.height - cPreviewHeight)
          ? details.offset.dy
          : details.offset.dy < 0
              ? 0
              : MediaQuery.of(context).size.height - cPreviewHeight;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Tooltip(
        message: 'Logout',
        child: IconButton(
          icon: Icon(Icons.logout),
          onPressed: _authCubit.handleLogout,
        ),
      ),
      body: Stack(
        children: [
          VideoPlayer(_videoController),
          DragTarget(
            builder: (context, List<Object?> candidateData, rejectedData) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              );
            },
            onWillAccept: (data) {
              return true;
            },
            onAccept: (data) {},
          ),
          if (cameras.isNotEmpty)
            Positioned(
              left: dx ??
                  MediaQuery.of(context).size.width -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      cPreviewWidth,
              top: dy ?? MediaQuery.of(context).size.height - cPreviewHeight,
              child: Draggable<int>(
                data: 1,
                child: RotatedBox(
                  quarterTurns: 4,
                  child: Container(
                    height: cPreviewHeight,
                    width: cPreviewWidth,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: CameraPreview(_cameraController),
                  ),
                ),
                feedback: Opacity(
                  opacity: 0.3,
                  child: Container(
                    height: cPreviewHeight,
                    width: cPreviewWidth,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: CameraPreview(_cameraController),
                  ),
                ),
                childWhenDragging: Container(),
                onDragEnd: _handleDragEnd,
              ),
            ),
          Positioned(
            bottom: Platform.isIOS ? 24 : 16,
            left: (MediaQuery.of(context).size.width / 2) - 100,
            child: Tooltip(
              message: 'Volume',
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Slider(
                  value: volume,
                  onChanged: _handleVolumeChange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
