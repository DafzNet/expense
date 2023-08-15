import 'package:expense/utils/constants/colors.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({super.key});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 30,
          height: 30,

          child: ClipOval(
            child: Container(
              color: appOrange,
            ),
          ),
        )
      ],
    );
  }
}