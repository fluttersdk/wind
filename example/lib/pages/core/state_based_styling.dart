import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class AppButton extends StatefulWidget {
  final String? className;
  final String? textClassName;
  final String? text;
  final bool disabled;

  const AppButton({
    super.key,
    this.className,
    this.textClassName,
    this.text,
    this.disabled = false,
  });

  @override
  State<StatefulWidget> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    List<String> states = [];

    if (widget.disabled) {
      states.add('disabled');
    }

    if (isHovered) {
      states.add('hover');
    }

    final String parsedClassName =
    classNameParser(widget.className, states: states);

    final String parsedTextClassName =
    classNameParser(widget.textClassName, states: states);

    return InkWell(
      onHover: (hovered) {
        if (!widget.disabled) {
          setState(() {
            isHovered = hovered;
          });
        }
      },
      onTap: () {
        if (!widget.disabled) {
          print('Button tapped');
        }
      },
      child: WFlexContainer(
        className: parsedClassName,
        children: [
          WText(
            widget.text ?? 'Button',
            className: parsedTextClassName,
          ),
        ],
      ),
    );
  }
}

class StateBasedStyling extends StatelessWidget {
  const StateBasedStyling({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'w-full h-full justify-center items-center flex-col bg-gray-200 gap-4',
      children: [
        AppButton(
          className: 'sm:w-full lg:w-100 bg-primary-500 p-4 rounded-lg items-center justify-center hover:bg-white',
          textClassName: 'text-white hover:text-primary-600',
          text: 'Submit',
        ),
        AppButton(
          className: 'sm:w-full lg:w-100 bg-primary-500 p-4 rounded-lg items-center justify-center disabled:bg-gray-500',
          textClassName: 'text-white disabled:text-black',
          text: 'Submit',
          disabled: true,
        ),
      ],
    );
  }
}
