import 'package:flutter/cupertino.dart';

class CreamCupertinoSheet extends StatelessWidget {
  const CreamCupertinoSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop('cream');
          },
          child: const Text('相机'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop('photo');
          },
          child: const Text('相册'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('取消'),
        onPressed: () {
          Navigator.of(context).pop('cancel');
        },
      ),
    );
  }
}
