import 'dart:async';

import 'package:flutter/widgets.dart';

typedef KeyboardHeightChangeCallBack = void Function(double keyboardHeight);

class BottomPositioned extends StatefulWidget {
  final Widget child;
  final KeyboardHeightChangeCallBack? keyboardChange;
  const BottomPositioned({required this.child, this.keyboardChange, super.key});

  @override
  State<StatefulWidget> createState() => _BottomPositionedState();
}

class _BottomPositionedState extends State<BottomPositioned> with WidgetsBindingObserver {
  double bottom = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(this);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // 更新 MediaQueryData 值
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    debugPrint("mediaQuery.viewInsets.bottom: height = $keyboardHeight");
    if (bottom == keyboardHeight) {
      // 需要判断 否则会死循环
      return;
    }

    // 当 size 变化的时候，触发刷新
    setState(() {
      bottom = keyboardHeight;
    });

    // widget.keyboardChange?.call(keyboardHeight);
  }

  @override
  Widget build(BuildContext context) {
    // // 获取 MediaQuery 数据
    // final mediaQuery = MediaQuery.of(context);
    // // 获取尺寸的操作应在帧渲染结束后进行
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _onKeyboardHeightChanged(mediaQuery));
    return Positioned(
        left: 0,
        right: 0,
        bottom: bottom,
        // duration: const Duration(milliseconds: 50),
        // curve: Curves.easeOut,
        child: widget.child);
  }

  Future<void> _onKeyboardHeightChanged(MediaQueryData mediaQuery) async {
    // if (_debounce?.isActive ?? false) _debounce?.cancel();
    // _debounce = Timer(const Duration(milliseconds: 300), () {
    //   final height = mediaQuery.viewInsets.bottom;
    //   // widget.keyboardChange?.call(height);
    //   // setState(() {
    //   //   bottom = height;
    //   // });
    //   // debugPrint('keyboard:set bottom = $bottom，${DateTime.now().millisecondsSinceEpoch}');
    //   if (bottom != height) {
    //     widget.keyboardChange?.call(height);
    //     setState(() {
    //       bottom = height;
    //     });
    //     debugPrint('keyboard:set bottom = $bottom，${DateTime.now().millisecondsSinceEpoch}');
    //   }
    // });

    final height = mediaQuery.viewInsets.bottom;
    if (bottom == height) {
      // 需要判断 否则会死循环
      return;
    }
    // widget.keyboardChange?.call(height);
    setState(() {
      bottom = height;
    });
  }
}