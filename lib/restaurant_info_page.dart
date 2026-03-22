import 'package:flutter/material.dart';

class RestaurantInfoPage extends StatelessWidget {
const RestaurantInfoPage({Key? key}) : super(key: key);
@override

Widget build(BuildContext context) {
// 建立AppBar
final appBar = AppBar(
title: const Text('第二頁'),
backgroundColor: const Color.fromARGB(255,97, 10, 4),
);
// 建立App的操作畫面
final btn = ElevatedButton(
child: const Text('回到上一頁'),
onPressed: () => Navigator. pop(context),
);
final widget = Container(
alignment: Alignment. topCenter,
padding: const EdgeInsets.all(30),
child: btn,
);
// 結合AppBar和App操作畫面
final page = Scaffold(
appBar: appBar,
body: widget,
backgroundColor: const Color.fromARGB(255, 220, 220, 220),
);

return page;
}
}