import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';

import '../../../injection.dart';

class RenameTierListDialog extends StatelessWidget {
  final int index;
  final String title;

  const RenameTierListDialog({
    Key? key,
    required this.index,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TierListFormBloc>(
      create: (ctx) => Injection.tierListFormBloc..add(TierListFormEvent.nameChanged(name: title)),
      child: _Body(index: index, title: title),
    );
  }
}

class _Body extends StatefulWidget {
  final int index;
  final String title;

  const _Body({
    Key? key,
    required this.index,
    required this.title,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late TextEditingController _textController;
  late String _currentValue;

  @override
  void initState() {
    _currentValue = widget.title;
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
    return AlertDialog(
      title: const Text('Rename'),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlocBuilder<TierListFormBloc, TierListFormState>(
          builder: (ctx, state) => ElevatedButton(
            onPressed: state.isNameValid ? _saveName : null,
            child: const Text('Save'),
          ),
        ),
      ],
      content: BlocBuilder<TierListFormBloc, TierListFormState>(
        builder: (ctx, state) => TextFormField(
          controller: _textController,
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLength: TierListFormBloc.nameMaxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          autofocus: true,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Name',
            hintText: 'Tier List Builder',
            errorText: !state.isNameValid && state.isNameDirty ? 'Invalid value' : null,
          ),
        ),
      ),
    );
  }

  void _saveName() {
    context.read<TierListBloc>().add(TierListEvent.rowTextChanged(index: widget.index, newValue: _textController.text));
    Navigator.pop(context);
  }

  void _textChanged() {
    if (_currentValue == _textController.text) {
      return;
    }

    _currentValue = _textController.text;
    context.read<TierListFormBloc>().add(TierListFormEvent.nameChanged(name: _currentValue));
  }
}

