import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/injection.dart';
import 'package:morningstar/presentation/shared/extensions/media_query_extensions.dart';
import 'package:morningstar/presentation/shared/loading.dart';

class ChangelogDialog extends StatelessWidget {
  const ChangelogDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return BlocProvider<ChangelogBloc>(
      create: (ctx) => Injection.changelogBloc..add(const ChangelogEvent.init()),
      child: AlertDialog(
        content: SizedBox(
          width: mq.getWidthForDialogs(),
          child: SingleChildScrollView(
            child: BlocBuilder<ChangelogBloc, ChangelogState>(
              builder: (ctx, state) => state.map(
                loading: (_) => const Loading(useScaffold: false),
                loaded: (state) => MarkdownBody(data: state.changelog),
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
