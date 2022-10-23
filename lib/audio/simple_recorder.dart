import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tyba_todo/services/database_services.dart';

/*
 * This is an example showing how to record to a Dart Stream.
 * It writes all the recorded data from a Stream to a File, which is completely stupid:
 * if an App wants to record something to a File, it must not use Streams.
 *
 * The real interest of recording to a Stream is for example to feed a
 * Speech-to-Text engine, or for processing the Live data in Dart in real time.
 *
 */

///
typedef _Fn = void Function();

/* This does not work. on Android we must have the Manifest.permission.CAPTURE_AUDIO_OUTPUT permission.
 * But this permission is _is reserved for use by system components and is not available to third-party applications._
 * Pleaser look to [this](https://developer.android.com/reference/android/media/MediaRecorder.AudioSource#VOICE_UPLINK)
 *
 * I think that the problem is because it is illegal to record a communication in many countries.
 * Probably this stands also on iOS.
 * Actually I am unable to record DOWNLINK on my Xiaomi Chinese phone.
 *
 */
//const theSource = AudioSource.voiceUpLink;
//const theSource = AudioSource.voiceDownlink;

const theSource = AudioSource.microphone;

/// Example app.
class SimpleRecorder extends StatefulWidget {
  String? audioRef;
  Function onSave;
  SimpleRecorder({super.key, this.audioRef, required this.onSave});
  @override
  _SimpleRecorderState createState() => _SimpleRecorderState(audioRef, onSave);
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  String? remoteRef;
  Function onSave;
  Codec _codec = Codec.aacMP4;
  String _fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
  String? _path;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  _SimpleRecorderState(this.remoteRef, this.onSave);

  @override
  void initState() {
    if (remoteRef != null) {
      DatabaseService().downloadAudio(remoteRef).then((String value) {
        setState(() {
          _path = value;
          _mplaybackReady = true;
        });
      });
    }

    _mPlayer!.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
        _mRecorderIsInited = true;
      });
    });

    _mRecorder!.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
        _mRecorderIsInited = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _mPlayer?.closeAudioSession();
    _mPlayer = null;

    _mRecorder?.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      bool isShown = await Permission.contacts.shouldShowRequestRationale;
      if (status != PermissionStatus.granted) {
        await openAppSettings();
      }
    }
    await _mRecorder!.startRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _fileName = '${DateTime.now().millisecondsSinceEpoch}.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _fileName,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {
        _path = _fileName;
      });
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      onSave(_fileName, value);
      setState(() {
        //var url = value;
        _mplaybackReady = true;
        _path = value;
      });
    });
  }

  void play() async {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);

    _mPlayer!
        .startPlayer(
            fromURI: _path,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: 80,
              child: Center(
                  child: const Text(
                'Voice Message',
                style: TextStyle(color: Colors.white),
              ))),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(1),
                padding: const EdgeInsets.all(1),
                height: 80,
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: getRecorderFn(),
                  icon: _mRecorder!.isRecording
                      ? const Icon(
                          Icons.stop_rounded,
                          color: Colors.white,
                        )
                      : const Icon(Icons.mic, color: Colors.white),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(1),
                padding: const EdgeInsets.all(1),
                height: 80,
                alignment: Alignment.center,
                child: IconButton(
                    color: Color(0xFFFAF0E6),
                    onPressed: getPlaybackFn(),
                    icon: Icon(
                        _mPlayer!.isPlaying
                            ? Icons.stop_rounded
                            : Icons.play_arrow_rounded,
                        color: _mplaybackReady ? Colors.white : Colors.grey)),
              ),
            ],
          ),
        ],
      );
    }

    return makeBody();
  }
}
