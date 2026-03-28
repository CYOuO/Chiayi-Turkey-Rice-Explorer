import 'package:flutter/material.dart';
import 'restaurant_data.dart';

class RestaurantInfoPage extends StatefulWidget {
  const RestaurantInfoPage({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoPage> createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage> {
  late Restaurant selectedShop;
  List<Restaurant> filteredRestaurants = []; // 搜尋用：用於搜尋過濾的店家列表
  final searchController = TextEditingController(); // 搜尋用：搜尋框控制器
  @override
  void initState() {
    super.initState();
    selectedShop = restaurants[0]; // 預設選第一間
    filteredRestaurants = restaurants; // 搜尋用：預設搜尋結果為全部店家
  }

  void _search() {
    // 搜尋用：根據搜尋框內容過濾店家列表
    setState(() {
      final keyword = searchController.text;
      if (keyword.isEmpty) {
        filteredRestaurants = restaurants;
      } else {
        filteredRestaurants =
            restaurants.where((shop) => shop.name.contains(keyword)).toList();
      }
    });
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
      actions: [
        // 搜尋用：搜尋框
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: '搜尋...',
                      hintStyle: TextStyle(color: Colors.white60),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white60),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _search, // ← 按 icon 才搜尋
                  child: const Icon(Icons.search, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );

    var dropdownMenu = DropdownMenu<Restaurant>(
      expandedInsets: EdgeInsets.zero, // 讓選單寬度撐滿
      label: const Text('請選擇店家'),
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Color.fromARGB(255, 254, 243, 243), // 下拉選單背景色
        ),
        elevation: WidgetStatePropertyAll(6),
      ),
      enableFilter: true,
      requestFocusOnTap: true,
      dropdownMenuEntries: filteredRestaurants.map((shop) {
        // 搜尋用：restaurants 改成 filteredRestaurants
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
