import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Hero Card Example - A showcase card for the Wind plugin landing page
/// Built entirely with Wind widgets
class HeroCardExamplePage extends StatelessWidget {
  const HeroCardExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: "flex items-center justify-center w-full h-full",
      child: WDiv(
        className: "w-96 rounded-3xl shadow-2xl bg-gray-800",
        children: [
          WDiv(
            className: "flex flex-col gap-4 p-6",
            children: [
              WDiv(
                className: "flex items-center gap-4",
                children: [
                  WImage(
                    src:
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
                    className: "w-20 h-20 rounded-full",
                  ),
                  WDiv(
                    children: [
                      WText(
                        "Anılcan Çakır",
                        className: "text-xl font-bold text-white",
                      ),
                      WText(
                        "Founder of Wind",
                        className: "text-sm text-purple-400",
                      ),
                    ],
                  ),
                ],
              ),
              WText(
                "Building beautiful UIs with Wind is incredibly fast and intuitive. It feels just like writing Tailwind but in Dart.",
                className: "text-base text-gray-300",
              ),
              WButton(
                onTap: () {},
                child: WDiv(
                  className: '''
                    w-full py-3 rounded-xl bg-gradient-to-r from-indigo-500
                    to-purple-500 text-white font-semibold text-center
                    hover:from-indigo-600 hover:to-purple-600 duration-300
                  ''',
                  child: WText("Follow"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
