import 'package:flutter/material.dart';

class RestaurantInfoPage extends StatefulWidget {
  const RestaurantInfoPage({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoPage> createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage> {
  final List<Map<String, String>> restaurants = [
    {
      'name': '民主雞肉飯',
      'image': 'assets/01minzu.jpg', 
      'address': '嘉義市東區民族路149號',
      'time': '每天10:00–20:40',
      'description': '假日常常大排長龍的店，但翻桌率很高。\n這家店的火雞肉飯口味獨特，深受當地人喜愛。\n有專屬停車場。',
      'phone': '05-216-2666',
    },
    {
      'name': '噴水雞肉飯-小雅旗艦店',
      'image': 'assets/02pensuei.jpg',
      'address': '嘉義市東區小雅路382號',
      'time': '每天10:30–20:00',
      'description': '著名觀光店，但其實非在地人首選。\n有專屬停車場。',
      'phone': '05-222-2433',
    },
    {
      'name': '檜町雞肉飯',
      'image': 'assets/03kuaiting.jpg',
      'address': '嘉義市東區吳鳳北路101號',
      'time': '11:00-15:00,17:00-20:00(週二、三、四公休)',
      'description': '裝潢小文青，環境舒適，有焗烤雞肉飯很獨特。',
      'phone': '05-222-7171',
    },
    {
      'name': '阿宏師火雞肉飯',
      'image': 'assets/04hong.jpg',
      'address': '嘉義市東區光華路108號',
      'time': '每天10:30–20:00',
      'description': '假日時期常大排長龍，多外地人，且不好停車。',
      'phone': '05-223-3467',
    },
    {
      'name': '嘉義體育館姊妹火雞肉飯',
      'image': 'assets/05sister.jpg',
      'address': '嘉義市東區垂楊路1號',
      'time': '06:00-14:00(週三公休)',
      'description': '創業於西元1987年，是許多嘉義人從小吃到大的老店。',
      'phone': '05-216-3755',
    },
    {
      'name': '嘉義人火雞肉飯',
      'image': 'assets/06cy.jpg',
      'address': '嘉義市東區垂楊路157號',
      'time': '05:30–14:00',
      'description': '早期是無名路邊攤起家，經營多年的老店。\n用餐時間人潮不斷，外面大馬路好停車。',
      'phone': '05-223-1737',
    },
    {
      'name': '陳家美食火雞肉飯',
      'image': 'assets/07chen.jpg',
      'address': '嘉義市西區民族路633號',
      'time': '11:00–04:00(週四公休)',
      'description': '內用是拋棄式碗筷，評價不高，是某些人的一次店。',
      'phone': '05-222-2748',
    },
    {
      'name': '圓環火雞大王火雞肉飯',
      'image': 'assets/08king.jpg',
      'address': '嘉義市東區民族路108號',
      'time': '10:30–21:00',
      'description': '評價感覺中規中矩，路邊有付費停車場。',
      'phone': '05-277-2233',
    },
    {
      'name': '阿樓師火雞肉飯',
      'image': 'assets/09lou.jpg',
      'address': '嘉義市東區吳鳳北路102號',
      'time': '16:00–00:00',
      'description': '人氣美食須排隊，附近也有超大停車場。',
      'phone': '05-228-2738',
    },
    {
      'name': '大同火雞肉飯',
      'image': 'assets/10tong.jpg',
      'address': '嘉義市東區民族路113號',
      'time': '10:00–16:00(週二公休)',
      'description': '飯粒粒分明，太晚到會蛋就沒有了，且是全熟蛋。',
      'phone': '05-275-5005',
    }
  ];
  late Map<String, String> selectedShop;

  @override
  void initState() {
    super.initState();
    selectedShop = restaurants[0]; // 預設選第一間
  }

  @override
  Widget build(BuildContext context) {
// 建立AppBar
    final appBar = AppBar(
      title: const Text(
        '店家資訊',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 97, 10, 4),
      iconTheme: const IconThemeData(
        color: Colors.white, // 將箭頭改為白色
      ),
    );

    var dropdownMenu = DropdownMenu<Map<String, String>>(
      initialSelection: restaurants[0],
      expandedInsets: EdgeInsets.zero, // 讓選單寬度撐滿
      label: const Text('請選擇店家'),
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Color.fromARGB(255, 254, 243, 243), // 下拉選單背景色
        ),
        elevation: WidgetStatePropertyAll(6),
      ),requestFocusOnTap: true,
      dropdownMenuEntries: restaurants.map((shop) {
        return DropdownMenuEntry<Map<String, String>>(
          value: shop,
          label: shop['name']!,
        );
      }).toList(),
      onSelected: (Map<String, String>? value) {
        if (!mounted) return;
        setState(() {
          if (value != null) selectedShop = value;
        });
      },
    );

    var restaurantInfo = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            selectedShop['image']!,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 店名
                Text(
                  selectedShop['name']!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 8),
                // 營業時間
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.access_time,
                        color: Color.fromARGB(255, 97, 10, 4), size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('營業時間',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(selectedShop['time']!,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 地址
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on,
                        color: Color.fromARGB(255, 97, 10, 4), size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('地址',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(selectedShop['address']!,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 電話
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.phone,
                        color: Color.fromARGB(255, 97, 10, 4), size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('電話',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(selectedShop['phone']!,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                // 介紹

                const Text('介紹',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  selectedShop['description']!,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
// 建立App的操作畫面
    var appBody = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: dropdownMenu,
        ),
        Expanded(child: restaurantInfo),
      ],
    );

// 結合AppBar和App操作畫面
    final page = Scaffold(
      appBar: appBar,
      body: appBody,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );

    return page;
  }
}
