import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      size: 35,
      type: SpinKitWaveType.end,
      itemCount: 4,
      itemBuilder: (context, index) {
        if (index % 2 == 0) {
          return Container(
            height: 10,
            width: 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor),
          );
        }
        return Container(
          height: 5,
          width: 1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor.withOpacity(0.5)),
        );
      },
    );
  }
}
