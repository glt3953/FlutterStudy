import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Underline Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWithUnderline(
                text: '这是一段包含中英文混排的文本，This is a text with underline.テスト테스트test테스트テスト',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextWithUnderline extends StatelessWidget {
  final String text;

  const TextWithUnderline({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String testText = '测试换行“中英文”""“”混排，text with underline. ‘テスト테스트test테스트テスト‘';
    // 创建一个 TextPainter 对象
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: testText, style: TextStyle(fontSize: 20.0)),
      maxLines: 999, // 设置最大行数
      textDirection: TextDirection.ltr,
    );
    // 对文本布局进行布局
    textPainter.layout(maxWidth: 2000);
    double height = textPainter.height;
    print('文本高度：$height');

    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        // children: _highlightText('“中英文”""“”混排，text with underline. ‘テスト테스트test테스트テスト‘'), //“中英文”""“”混排，text with underline. ‘テスト테스트test테스트テスト‘
        children: _highlightTextDemo('测试换行“中英文”""“”混排，text with underline. ‘テスト테스트test테스트テスト‘', height),
      ),
    );
   // return DecoratedBox(
   //    decoration: BoxDecoration(
   //      // border: Border(bottom: BorderSide()),
   //      color: const Color(0xFFFF6933),
   //    ),
   //    child: Text(
   //      '“中英文”""“”混排，text with underline. テスト테스트test테스트テスト‘',
   //      style: TextStyle(fontSize: 24.0),
   //      // selectionColor: const Color(0xFFFF6933),
   //    ),
   //  );
  }

  /// 文本高亮
  List<InlineSpan> _highlightTextDemo(
      String content, double height) {
    List<InlineSpan> spans = [];

    for (int i = 0; i < content.length; i++) {
      spans.add(WidgetSpan(
        child: Container(
          child:
            Text(content[i], style: TextStyle(fontSize: 20.0),),
            color: const Color(0xFFFF6933),
        ),
      ));
    }

    spans.add(TextSpan(
      text: '\n\n',
    ));

    final RegExp englishWord = RegExp(r'[A-Za-z]+');
    final List<String> segments = content.split(englishWord);
    final Iterable<Match> matches = englishWord.allMatches(content);

    //中文按字符输出
    int index = 0;
    for (final Match match in matches) {
      if (match.start > index) {
        print('中文：'+content.substring(index, match.start));
        String text = content.substring(index, match.start);
        for (int i = 0; i < text.length; i++) {
          spans.add(WidgetSpan(
            child: Container(
              child:
              Text(text[i], style: TextStyle(fontSize: 20.0),),
              color: const Color(0xFFFF6933),
              height: height,
            ),
          ));
        }
      }
      print('英文：'+match.group(0)!);
      spans.add(WidgetSpan(
        child: Container(
          child:
          Text(match.group(0)!, style: TextStyle(fontSize: 20.0),),
          color: const Color(0xFFFF6933),
          height: height,
        ),
      ));
      index = match.end;
    }

    if (index < content.length) {
      print('中文：'+content.substring(index));
      spans.add(WidgetSpan(
        child: Container(
          child:
          Text(content.substring(index), style: TextStyle(fontSize: 20.0),),
          color: const Color(0xFFFF6933),
          height: height,
        ),
      ));
    }

    spans.add(TextSpan(
      text: '\n\n',
    ));

    //中文整体输出
    index = 0;
    for (final Match match in matches) {
      if (match.start > index) {
        print('中文：'+content.substring(index, match.start));
        spans.add(WidgetSpan(
          child: Container(
            child:
            Text(content.substring(index, match.start), style: TextStyle(fontSize: 20.0),),
            color: const Color(0xFFFF6933),
          ),
        ));
      }
      print('英文：'+match.group(0)!);
      spans.add(WidgetSpan(
        child: Container(
          child:
          Text(match.group(0)!, style: TextStyle(fontSize: 20.0),),
          color: const Color(0xFFFF6933),
        ),
      ));
      index = match.end;
    }

    if (index < content.length) {
      spans.add(WidgetSpan(
        child: Container(
          child:
          Text(content.substring(index), style: TextStyle(fontSize: 20.0),),
          color: const Color(0xFFFF6933),
        ),
      ));
    }

    spans.add(TextSpan(
      text: '\n\n',
    ));

    List<String> words = content.split(" ");
    words.forEach((word) {
      spans.add(WidgetSpan(
        child: Container(
          child:
          Text(word+" ", style: TextStyle(fontSize: 20.0),),
          color: const Color(0xFFFF6933),
        ),
      ));
      // for (int i = 0; i < word.length; i++) {
      //   spans.add(WidgetSpan(
      //     child: Container(
      //       child:
      //       Text(word[i], style: TextStyle(fontSize: 20.0),),
      //       color: const Color(0xFFFF6933),
      //     ),
      //   ));
      // }
    });

    spans.add(TextSpan(
      text: '\n\n',
    ));

    spans.add(WidgetSpan(
      child: Container(
        child:
          Text(content, style: TextStyle(fontSize: 20.0),),
          color: const Color(0xFFFF6933),
      ),
    ));

    spans.add(TextSpan(
      text: '\n\n',
    ));

    spans.add(TextSpan(
      text: content+'\n\n',
      style: TextStyle(
        backgroundColor: const Color(0xFFFF6933),
      ),
    ));

    spans.add(TextSpan(
      text: content+'\n\n',
      style: TextStyle(
        color: const Color(0xFFFF6933),
        fontWeight: FontWeight.bold,
      ),
    ));

    spans.add(TextSpan(
            text: content+'\n\n',
            style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFFFF6933),
                decorationThickness: 1.5,
                decorationStyle: TextDecorationStyle.solid,
            ),
          ));

    return spans;
  }

  /// 文本高亮
  List<InlineSpan> _highlightText(
      String content) {
    List<InlineSpan> spans = [];

    // spans.add(TextSpan(
    //       text: content,
    //       style: TextStyle(
    //           decoration: TextDecoration.underline,
    //           decorationColor: const Color(0xFFFF6933),
    //           decorationThickness: 1.5,
    //           decorationStyle: TextDecorationStyle.solid,
    //           color: const Color(0xFF59597C)),
    //     ));
    spans.add(TextSpan(
      text: content,
      style: TextStyle(
          // backgroundColor: const Color(0xFFFF6933),
          textBaseline: TextBaseline.alphabetic,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFFFF6933),
          decorationThickness: 1.5,
          decorationStyle: TextDecorationStyle.solid,
          color: const Color(0xFF59597C)
        ),
    ));


    // String text = "“中英文”""“”混排，text with underline. テスト테스트test테스트テスト‘";
    //
    // // 将字符串转换为Unicode编码的文本
    // List<int> unicodeCodeUnits = text.codeUnits;
    // print("Unicode编码的文本: $unicodeCodeUnits");
    //
    // // 将Unicode码点列表转换回字符串
    // String decodedText = String.fromCharCodes(unicodeCodeUnits);
    // print("解码后的文本: $decodedText");

    // String originalString = '“中英文”""“”混排，text with underline. テスト테스트test테스트テスト‘';
    //
    // List<int> utf8Bytes = utf8.encode(originalString);
    // String utf8String = utf8.decode(utf8Bytes);
    //
    // print('Original String: $originalString');
    // print('UTF-8 Bytes: $utf8Bytes');
    // print('UTF-8 String: $utf8String');

    return spans;
  }
}
