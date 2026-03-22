import 'package:flutter/material.dart';
import 'restaurant_info_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp( 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'TWSung',),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 建立標題物件
    var mainTitle = const Text(
      'Turkey Rice Explorer',
      style: TextStyle(
        fontSize: 34,
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 35,
            color: Color.fromARGB(199, 208, 164, 98),
            offset: Offset(-2, -2),
          ),
          Shadow(
            blurRadius: 10,
            color: Color.fromARGB(180, 0, 0, 0),
            offset: Offset(5, 5),
          ),
        ],
      ),
    );
    var subTitle = const Text(
      'A Local\'s Guide to Delicious Food',
      style: TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 20,
              color: Color.fromARGB(180, 255, 200, 120),
              offset: Offset(0, 0),
            ),
            Shadow(
              blurRadius: 6,
              color: Color.fromARGB(159, 68, 33, 7),
              offset: Offset(3, 3),
            ),
          ]),
    );
    // 建立背景物件
    var background = Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('./assets/home_background.JPG'),
          fit: BoxFit.cover,
        ),
      ),
    );

    // 建立遮罩物件
    var mask = Container(
      color: const Color.fromARGB(171, 30, 10, 0),
    );

    // 建立標籤物件
    var tags = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTag('📍 嘉義市區'),
        const SizedBox(width: 8),
        _buildTag('⭐在地美食'),
        const SizedBox(width: 8),
        _buildTag('🍗 火雞肉飯'),
      ],
    );

    // 建立首頁button物件
    var startButton = ElevatedButton(
      onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantInfoPage())),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        foregroundColor: Colors.brown,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundBuilder: (context, states, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: states.contains(WidgetState.pressed)
                    ? [
                        Color.fromARGB(200, 255, 220, 160), // 按下變深
                        Colors.white.withValues(alpha: 0.6),
                      ]
                    : [
                        const Color.fromARGB(255, 246, 196, 196)
                            .withValues(alpha: 0.95), // 一般狀態漸層
                        Color.fromARGB(200, 255, 220, 160),
                      ],
              ),
            ),
            child: child,
          );
        },
      ),
      child: const Text(
        '開始探索',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // 建立appBody物件
    var appBody = Stack(
      children: [
        background,
        mask,
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [mainTitle, subTitle],
          ),
        ),
        
        OrientationBuilder(
          builder: (context, orientation) {
            return Align(
              alignment: Alignment(
                0,
                orientation == Orientation.portrait ? 0.25 : 0.75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: tags),
                  const SizedBox(height: 20),
                  startButton,
                ],
              ),
            );
          },
        ),
      ],
    );

    // 建立app物件
    final app = Scaffold(
      body: appBody,
    );
    return app;
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white54),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
