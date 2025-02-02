import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class MarginWidget extends StatelessWidget {
  const MarginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center flex-col justify-center axis-max bg-white',
      children: [
        WContainer(
          className: 'bg-gray-200 w-full h-4',
        ),
        WContainer(
          className: 'm-4 bg-gray-200',
          child: WText('This container has 16px margin.'),
        ),
        WContainer(
          className: 'bg-gray-200 w-full h-4',
        ),
      ],
    );
  }
}

class MarginArbitraryWidget extends StatelessWidget {
  const MarginArbitraryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center flex-col justify-center axis-max bg-white',
      children: [
        WContainer(
          className: 'bg-gray-200 w-full h-4',
        ),
        WContainer(
          className: 'm-[10] bg-gray-200',
          child: WText('This container has 10px margin.'),
        ),
        WContainer(
          className: 'bg-gray-200 w-full h-4',
        ),
      ],
    );
  }
}

class MarginSpecificWidget extends StatelessWidget {
  const MarginSpecificWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center flex-col justify-center axis-max bg-white',
      children: [
        WContainer(
          className: 'bg-gray-200 w-full h-4',
        ),
        WFlexContainer(className: 'flex-row', children: [
          WContainer(
            className: 'bg-gray-200 flex-1 h-4',
          ),
          WContainer(
            className: 'mt-4 mr-[8] ml-2 mb-[12] bg-gray-200',
            child: WText('Custom side-specific margin applied.'),
          ),
          WContainer(
            className: 'bg-gray-200 flex-1 h-4',
          )
        ]),
        WContainer(
          className: 'bg-gray-200 w-full h-4',
        ),
      ],
    );
  }
}
