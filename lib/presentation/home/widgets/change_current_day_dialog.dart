import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/extensions/media_query_extensions.dart';

class ChangeCurrentDayDialog extends StatefulWidget {
  final int currentSelectedDay;
  const ChangeCurrentDayDialog({Key? key, required this.currentSelectedDay}) : super(key: key);

  @override
  _ChangeCurrentDayDialogState createState() => _ChangeCurrentDayDialogState();
}

class _ChangeCurrentDayDialogState extends State<ChangeCurrentDayDialog> {
  late int currentSelectedDay;

  @override
  void initState() {
    currentSelectedDay = widget.currentSelectedDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final days = <int, String>{
      DateTime.monday: 'Monday',
      DateTime.tuesday: 'Tuesday',
      DateTime.wednesday: 'Wednesday',
      DateTime.thursday: 'Thursday',
      DateTime.friday: 'Friday',
      DateTime.saturday: 'Saturday',
      DateTime.sunday: 'Sunday',
    };

    return AlertDialog(
      title: const Text('Day'),
      content: SizedBox(
        width: mq.getWidthForDialogs(),
        height: mq.getHeightForDialogs(days.length),
        child: ListView.builder(
          itemCount: days.entries.length,
          itemBuilder: (ctx, index) {
            final day = days.entries.elementAt(index);
            return Material(
              color: Colors.transparent,
              child: ListTile(
                key: Key('$index'),
                title: Text(day.value, overflow: TextOverflow.ellipsis),
                selected: currentSelectedDay == day.key,
                selectedTileColor: theme.colorScheme.secondary.withOpacity(0.2),
                onTap: () {
                  setState(() {
                    currentSelectedDay = day.key;
                  });
                },
              ),
            );
          },
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: theme.primaryColor)),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop<int>(context, -1),
          child: Text('Restore', style: TextStyle(color: theme.primaryColor)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop<int>(context, currentSelectedDay),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
