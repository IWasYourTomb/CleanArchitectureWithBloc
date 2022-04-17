import 'package:flutter/material.dart';

enum LiveStatus{alive, dead, unknown}

class Status extends StatelessWidget{
  final LiveStatus status;
  const Status({Key ? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 11,
            color: status == LiveStatus.alive
              ? Colors.lightGreenAccent[400]
                : status == LiveStatus.dead
              ? Colors.black
                : Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            status == LiveStatus.dead
                ? 'Мертв'
                : status == LiveStatus.alive
                ? 'Жив'
                : 'Неизвестно',
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      );
  }
}