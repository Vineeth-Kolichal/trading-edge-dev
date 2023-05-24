import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

class WidgetSearchGif extends StatefulWidget {
  const WidgetSearchGif({super.key});

  @override
  State<WidgetSearchGif> createState() => _WidgetSearchGifState();
}

class _WidgetSearchGifState extends State<WidgetSearchGif>
    with TickerProviderStateMixin {
  late FlutterGifController controller;
  @override
  void initState() {
    super.initState();
    controller = FlutterGifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.repeat(
        min: 0,
        max: 60,
        period: const Duration(milliseconds: 2000),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: GifImage(
        controller: controller,
        image: const AssetImage(
          "assets/gifs/search.gif",
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
