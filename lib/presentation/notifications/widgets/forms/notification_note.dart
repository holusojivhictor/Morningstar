import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';

class NotificationNote extends StatefulWidget {
  final String? note;

  const NotificationNote({Key? key, required this.note}) : super(key: key);

  @override
  _NotificationNoteState createState() => _NotificationNoteState();
}

class _NotificationNoteState extends State<NotificationNote> {
  late TextEditingController _textController;
  String? _currentValue;

  @override
  void initState() {
    _currentValue = widget.note;
    _textController = TextEditingController(text: _currentValue);
    _textController.addListener(_textChanged);
    super.initState();
  }

  @override
  void dispose() {
    _textController.removeListener(_textChanged);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (ctx, state) {
        if (state.note != _currentValue) {
          setState(() {
            _currentValue = state.note;
            _textController.text = _currentValue!;
          });
        }
      },
      builder: (ctx, state) => TextField(
        maxLength: NotificationBloc.maxNoteLength,
        controller: _textController,
        keyboardType: TextInputType.text,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: 'Note',
          alignLabelWithHint: true,
          labelText: 'Note',
        ),
      ),
    );
  }

  void _textChanged() {
    // Focusing the text field triggers text change, so we have to do this
    if (_currentValue == _textController.text) {
      return;
    }
    _currentValue = _textController.text;
    context.read<NotificationBloc>().add(NotificationEvent.noteChanged(newValue: _textController.text));
  }
}
