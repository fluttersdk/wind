import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class PaddingWidget extends StatelessWidget {
  const PaddingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center flex-row gap-4 justify-center axis-max bg-white',
      children: [
        WContainer(
          className: 'p-4 bg-gray-200',
          child: WText('This container has 16px padding.'),
        )
      ],
    );
  }
}

class PaddingArbitraryWidget extends StatelessWidget {
  const PaddingArbitraryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center flex-row gap-4 justify-center axis-max bg-white',
      children: [
        WContainer(
          className: 'p-[10] bg-gray-200',
          child: WText('This container has 10px padding.'),
        )
      ],
    );
  }
}

class PaddingSpecificWidget extends StatelessWidget {
  const PaddingSpecificWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center flex-row gap-4 justify-center axis-max bg-white',
      children: [
        WContainer(
          className: 'pt-4 pr-[8] pl-2 pb-[12] bg-gray-200',
          child: WText('Custom side-specific padding applied.'),
        )
      ],
    );
  }
}