import 'package:flutter/material.dart';
import 'restaurant_data.dart';

class RestaurantInfoPage extends StatefulWidget {
  const RestaurantInfoPage({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoPage> createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage> {
  late Restaurant selectedShop;
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

    var dropdownMenu = DropdownMenu<Restaurant>(
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
        return DropdownMenuEntry<Restaurant>(
          value: shop,
          label: shop.name,
        );
      }).toList(),
      onSelected: (Restaurant? value) {
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
            selectedShop.image,
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
                  selectedShop.name,
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
                        Text(selectedShop.time,
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
                        Text(selectedShop.address,
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
                        Text(selectedShop.phone,
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
                  selectedShop.description,
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
