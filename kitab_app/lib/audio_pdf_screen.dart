import 'dart:async';
import 'audio_state_storage.dart';
import 'note_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AudioPdfScreen extends StatefulWidget {
  final String title;
  final String audioPath;
  final String pdfPath;

  const AudioPdfScreen({
    Key? key,
    required this.title,
    required this.audioPath,
    required this.pdfPath,
  }) : super(key: key);

  @override
  State<AudioPdfScreen> createState() => _AudioPdfScreenState();
}

class _AudioPdfScreenState extends State<AudioPdfScreen>
    with AutomaticKeepAliveClientMixin {
  static const Color _deepGreen = Color(0xFF0F622A);
  static const Color _midGreen = Color(0xFF1A7A39);
  static const Color _textGreen = Color(0xFF185F2E);

  int _audioDuration = 0;
  int _audioPosition = 0;
  bool _sourceInitialized = false;
  
  late PdfViewerController _pdfController;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  
  bool _notesLoading = true;
  List<String> _notes = [];
  bool _notesExpanded = false;
  final TextEditingController _noteController = TextEditingController();
  
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;

  String get _lessonKey => widget.audioPath;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _audioPlayer = AudioPlayer();

    _setupAudioListeners();
    _initAudioSource();
    _loadNotes();
  }

  void _setupAudioListeners() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (!mounted) return;
      setState(() => _audioDuration = duration.inMilliseconds);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((Duration position) {
      if (!mounted) return;
      setState(() => _audioPosition = position.inMilliseconds);
      
      // Save state every 5 seconds to avoid excessive disk I/O
      if (position.inSeconds % 5 == 0) {
        AudioStateStorage.saveAudioState(widget.audioPath, _audioPosition);
      }
    });

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => isPlaying = state == PlayerState.playing);
    });
  }

  Future<void> _initAudioSource() async {
    final assetPath = widget.audioPath.replaceFirst('assets/', '');
    await _audioPlayer.setSource(AssetSource(assetPath));
    _sourceInitialized = true;
    
    // Restore previous position
    final state = await AudioStateStorage.loadAudioState();
    if (state != null && state['audioPath'] == widget.audioPath) {
      final savedPos = state['position'] ?? 0;
      await _audioPlayer.seek(Duration(milliseconds: savedPos));
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _noteController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    if (!_sourceInitialized) return;

    if (isPlaying) {
      await _audioPlayer.pause();
      await AudioStateStorage.saveAudioState(widget.audioPath, _audioPosition);
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> _loadNotes() async {
    final notes = await NoteStorage.loadNotes(_lessonKey);
    if (!mounted) return;
    setState(() {
      _notes = notes;
      _notesLoading = false;
    });
  }

  Future<void> _saveNotes(List<String> notes) async {
    await NoteStorage.saveNotes(_lessonKey, notes);
    if (!mounted) return;
    setState(() => _notes = notes);
  }

  void _toggleNotesPanel() {
    setState(() => _notesExpanded = !_notesExpanded);
  }

  Future<void> _addNote() async {
    final note = _noteController.text.trim();
    if (note.isEmpty) return;

    final updatedNotes = List<String>.from(_notes)..add(note);
    _noteController.clear();
    await _saveNotes(updatedNotes);
  }

  Future<void> _deleteNote(int index) async {
    final updatedNotes = List<String>.from(_notes)..removeAt(index);
    await _saveNotes(updatedNotes);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: _midGreen,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                _notesLoading ? '...' : '${_notes.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.sticky_note_2_outlined, color: Colors.white),
              onPressed: _toggleNotesPanel,
              tooltip: _notesExpanded ? 'Hide notes' : 'Show notes',
            ),
          ],
        ),
        backgroundColor: _deepGreen,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.asset(
              widget.pdfPath,
              controller: _pdfController,
            ),
          ),
          if (_notesExpanded) _buildNotesPanel(),
          _buildAudioControls(),
        ],
      ),
    );
  }

  Widget _buildNotesPanel() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 240),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFD8E6DA))),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold, color: _textGreen)),
              Text('${_notes.length}', style: const TextStyle(color: _midGreen)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              hintText: 'Type a note...',
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: _addNote,
                style: ElevatedButton.styleFrom(backgroundColor: _midGreen),
                child: const Text('Add Note', style: TextStyle(color: Colors.white)),
              ),
              TextButton(onPressed: _toggleNotesPanel, child: const Text('Close')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_notes[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => _deleteNote(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControls() {
    return SafeArea(
      top: false,
      child: Container(
        color: _deepGreen,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _toggleAudio,
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _audioPosition.toDouble().clamp(0, _audioDuration.toDouble()),
                    max: _audioDuration > 0 ? _audioDuration.toDouble() : 1.0,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(Duration(milliseconds: _audioPosition)), 
                       style: const TextStyle(color: Colors.white, fontSize: 12)),
                  Text(_formatDuration(Duration(milliseconds: _audioDuration)), 
                       style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
