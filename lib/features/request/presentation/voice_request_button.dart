import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceRequestButton extends StatefulWidget {
  final Function(String) onResult;
  const VoiceRequestButton({super.key, required this.onResult});

  @override
  State<VoiceRequestButton> createState() => _VoiceRequestButtonState();
}

class _VoiceRequestButtonState extends State<VoiceRequestButton> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
             if (val.hasConfidenceRating && val.confidence > 0) {
               widget.onResult(val.recognizedWords);
             }
             if (val.finalResult) {
                 setState(() => _isListening = false);
             }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AvatarGlow( // Custom simplistic glow or just icon color change
      animate: _isListening,
      child: FloatingActionButton(
        onPressed: _listen,
        backgroundColor: _isListening ? Colors.red : Colors.blue,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
}

// Simple Glow widget stub since we don't have avatar_glow package yet, 
// just standard FAB for now to save complexity.
class AvatarGlow extends StatelessWidget {
    final bool animate;
    final Widget child;
    const AvatarGlow({super.key, required this.animate, required this.child});
    @override 
    Widget build(BuildContext context) {
        return Container(
            decoration: animate ? BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)]
            ) : null,
            child: child
        );
    }
}
