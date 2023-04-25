import 'package:flutter/material.dart';

class SpacerWidget extends StatelessWidget {
  const SpacerWidget({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height;
  final double? width;

  const SpacerWidget.vertical8({Key? key})
      : height = 8,
        width = 0,
        super(key: key);

  const SpacerWidget.vertical16({Key? key})
      : height = 16,
        width = 0,
        super(key: key);

  const SpacerWidget.vertical24({Key? key})
      : height = 24,
        width = 0,
        super(key: key);

  const SpacerWidget.vertical32({Key? key})
      : height = 32,
        width = 0,
        super(key: key);

  const SpacerWidget.vertical(this.height, {Key? key})
      : width = 0,
        super(key: key);

  const SpacerWidget.horizontal8({Key? key})
      : height = 0,
        width = 08,
        super(key: key);

  const SpacerWidget.horizontal16({Key? key})
      : height = 0,
        width = 16,
        super(key: key);

  const SpacerWidget.horizontal24({Key? key})
      : height = 0,
        width = 24,
        super(key: key);

  const SpacerWidget.horizontal32({Key? key})
      : height = 0,
        width = 32,
        super(key: key);

  const SpacerWidget.horizontal(this.width, {Key? key})
      : height = 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
