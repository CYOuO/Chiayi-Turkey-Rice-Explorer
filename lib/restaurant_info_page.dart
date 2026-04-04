import 'package:flutter/material.dart';
import 'restaurant_data.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantInfoPage extends StatefulWidget {
  const RestaurantInfoPage({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoPage> createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage> {
  late Restaurant selectedShop;
  int _currentImageIndex = 0;
  late PageController _pageController;
  List<Restaurant> filteredRestaurants = []; // 搜尋用：用於過濾的店家列表
  String _selectedFilter = '全部'; // 新增篩選狀態
  @override
  void initState() {
    super.initState();
    selectedShop = restaurants[0]; // 預設選第一間
    filteredRestaurants = restaurants; // 搜尋用：預設搜尋結果為全部店家
    _pageController = PageController();
  }

  void _applyFilter() {
    final Map<String, String> dayMap = {
      '星期一': '週一',
      '星期二': '週二',
      '星期三': '週三',
      '星期四': '週四',
      '星期五': '週五',
      '星期六': '週六',
      '星期日': '週日',
    };
    bool _isClosedOn(String time, String dayKeyword) {
      // 找到「公休」前面的那段文字，例如「週二、三、四」
      final regex = RegExp(r'[（(]([^）)]+公休)[）)]');
      final match = regex.firstMatch(time);
      if (match == null) return false;

      final closedSection = match.group(1)!; // 例如「週二、三、四公休」

      // 把「週X」拆開來比對
      // dayKeyword 例如「週四」
      final shortDay = dayKeyword.replaceAll('週', ''); // 變成「四」

      // 檢查是否包含完整的「週四」或縮寫「四」（在頓號分隔的情況）
      return closedSection.contains('週$shortDay') ||
          closedSection.contains('、$shortDay') ||
          closedSection.contains('週$shortDay、') ||
          RegExp('週[一二三四五六日、]*${shortDay}[、公]').hasMatch(closedSection);
    }

    setState(() {
      if (_selectedFilter == '全部') {
        filteredRestaurants = restaurants;
      } else {
        final closedKeyword = dayMap[_selectedFilter]!;
        // 公休日包含該關鍵字的排除掉
        filteredRestaurants = restaurants
            .where((shop) => !_isClosedOn(shop.time, closedKeyword))
            .toList();
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
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white),
          onSelected: (String value) {
            setState(() {
              _selectedFilter = value;
              _applyFilter();
            });
          },
          itemBuilder: (context) => [
            '全部',
            '星期一',
            '星期二',
            '星期三',
            '星期四',
            '星期五',
            '星期六',
            '星期日',
          ]
              .map((label) => PopupMenuItem(
                    value: label,
                    child: Row(
                      children: [
                        if (_selectedFilter == label)
                          const Icon(Icons.check,
                              size: 18, color: Color.fromARGB(255, 97, 10, 4))
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(label),
                      ],
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(width: 8),
      ],
    );

    var dropdownMenu = DropdownMenu<Restaurant>(
      expandedInsets: EdgeInsets.zero, // 讓選單寬度撐滿
      label: const Text('請選擇店家'),
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 255, 248, 240), // 下拉選單背景色
        ),
        elevation: WidgetStatePropertyAll(6),
        maximumSize: WidgetStatePropertyAll(
          Size(double.infinity, 300), // 限制選單最高 300
        ),
      ),
      enableFilter: true,
      requestFocusOnTap: true,
      dropdownMenuEntries: filteredRestaurants.map((shop) {
        // 搜尋用：restaurants 改成 filteredRestaurants
        return DropdownMenuEntry<Restaurant>(
          value: shop,
          label: shop.name,
          leadingIcon: const Icon(Icons.restaurant, color: Colors.grey),
          labelWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(shop.name, style: const TextStyle(fontSize: 15)),
              Text(shop.address,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      }).toList(),
      filterCallback: (entries, filter) {
        return entries
            .where((entry) =>
                entry.label.contains(filter) ||
                entry.value.address.contains(filter))
            .toList();
      },
      onSelected: (Restaurant? value) {
        if (!mounted) return;
        setState(() {
          if (value != null) {
            selectedShop = value;
            _currentImageIndex = 0;
            _pageController.jumpToPage(0);
          }
        });
      },
    );

    var restaurantInfo = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              children: [
                PhotoViewGallery.builder(
                  pageController: _pageController,
                  itemCount: selectedShop.images.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: AssetImage(selectedShop.images[index]),
                      initialScale: PhotoViewComputedScale.covered,
                      minScale: PhotoViewComputedScale.covered,
                      maxScale: PhotoViewComputedScale.covered,
                    );
                  },
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.black),
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                ),
                // 圓點指示
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      selectedShop.images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentImageIndex == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 店名
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      selectedShop.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 54, 13, 13),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(30, 97, 10, 4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        selectedShop.price,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 97, 10, 4), // 深紅字
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 8),
                if (_currentImageIndex != 2) ...[
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
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
                ] else ...[
                  const SizedBox(height: 0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 248, 240),
                      //borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color.fromARGB(255, 210, 170, 120),
                          width: 1.5),
                    ),
                    child: Column(
                      children: [
                        const Text('🦃', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          '出發去 ${selectedShop.name}！',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 97, 10, 4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => launchUrl(
                              Uri.parse(
                                  'https://maps.google.com/?q=${selectedShop.address}'),
                            ),
                            icon: const Icon(Icons.map),
                            label: const Text('在 Google Maps 開啟'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 97, 10, 4),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
