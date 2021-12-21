import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';

class NotificationTitleBody extends StatefulWidget {
  final String title;
  final String body;

  const NotificationTitleBody({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  State<NotificationTitleBody> createState() => _NotificationTitleBodyState();
}

class _NotificationTitleBodyState extends State<NotificationTitleBody> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  late String _title;
  late String _body;

  @override
  void initState() {
    _title = widget.title;
    _body = widget.body;

    _titleController = TextEditingController(text: _title);
    _bodyController = TextEditingController(text: _body);
    
    _titleController.addListener(_titleChanged);
    _bodyController.addListener(_bodyChanged);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.removeListener(_titleChanged);
    _bodyController.removeListener(_bodyChanged);
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 45,
          fit: FlexFit.tight,
          child: BlocConsumer<NotificationBloc, NotificationState>(
            listener: (ctx, state) {
              if (state.title != _title || state.body != _body) {
                setState(() {
                  _title = state.title;
                  _titleController.text = _title;
                });
              }
            },
            builder: (ctx, state) => TextField(
              controller: _titleController,
              maxLength: NotificationBloc.maxTitleLength,
              keyboardType: TextInputType.text,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: 'Title',
                alignLabelWithHint: true,
                labelText: 'Title',
                errorText: !state.isTitleValid && state.isTitleDirty ? 'Invalid value' : null,
              ),
            ),
          ),
        ),
        const Spacer(flex: 10),
        Flexible(
          flex: 45,
          fit: FlexFit.tight,
          child: BlocConsumer<NotificationBloc, NotificationState>(
            listener: (ctx, state) {
              if (state.body != _body) {
                setState(() {
                  _body = state.body;
                  _bodyController.text = _body;
                });
              }
            },
            builder: (ctx, state) => TextField(
              controller: _bodyController,
              maxLength: NotificationBloc.maxBodyLength,
              keyboardType: TextInputType.text,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: 'Body',
                alignLabelWithHint: true,
                labelText: 'Body',
                errorText: !state.isBodyValid && state.isBodyDirty ? 'Invalid value' : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _titleChanged() {
    // Focusing the text field triggers text change, so we have to do this
    if (_title == _titleController.text) {
      return;
    }
    _title = _titleController.text;
    context.read<NotificationBloc>().add(NotificationEvent.titleChanged(newValue: _titleController.text));
  }
  
  void _bodyChanged() {
    // Focusing the text field triggers text change, so we have to do this
    if (_body == _bodyController.text) {
      return;
    }
    _body = _bodyController.text;
    context.read<NotificationBloc>().add(NotificationEvent.bodyChanged(newValue: _bodyController.text));
  }
}
