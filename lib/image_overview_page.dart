import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'restaurant_data.dart';

class ImageOverviewPage extends StatefulWidget {
  final Restaurant restaurant;
  const ImageOverviewPage({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<ImageOverviewPage> createState() => _ImageOverviewPageState();
}

class _ImageOverviewPageState extends State<ImageOverviewPage> {
  late Restaurant _current;
  int _crossAxisCount = 3;

  static const _bgOffWhite = Color(0xFFFAF5F0); // 主背景色：暖米白
  static const _surfaceLatte = Color(0xFFF3EAE1); // 選單與資訊列：燕麥色
  static const _accentRed = Color(0xFF610A04); // 強調色：深紅
  static const _textDark = Color(0xFF360D0D); // 主文字：深咖啡色
  static const _textMuted = Color(0xFF8A7366); // 次要文字與圖示：暖褐色
  static const _dividerColor = Color(0xFFDFD1C4); // 分隔線：淡奶茶色

  @override
  void initState() {
    super.initState();
    _current = widget.restaurant;
  }

  // ── 全螢幕放大 ──────────────────────────────────────────
  void _openFullScreen(int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        // 自訂轉場動畫
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, __, ___) => _FullScreenViewer(
          images: _current.images,
          initialIndex: index,
          restaurantName: _current.name,
          heroPrefix: 'grid_${_current.id}',
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  // ── 長按圖片資訊 ──
  void _showImageInfo(int index) {
    final path = _current.images[index];
    final fileName = path.split('/').last;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: _bgOffWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  path,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '圖片 ${index + 1} / ${_current.images.length}',
                      style: const TextStyle(
                        color: _textDark,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _current.name,
                      style: const TextStyle(
                          color: _accentRed,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 20),
            const Divider(color: _dividerColor),
            const SizedBox(height: 12),
            _infoRow(Icons.image_outlined, '檔案名稱', fileName),
            _infoRow(Icons.store_outlined, '所屬店家', _current.name),
            _infoRow(Icons.location_on_outlined, '地址', _current.address),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _textMuted, size: 16),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(label,
                style: const TextStyle(color: _textMuted, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: _textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // ── 切換店家 Bottom Sheet ──────────────────────
  void _showRestaurantSwitcher() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (ctx, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: _bgOffWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.store_mall_directory,
                            color: _accentRed, size: 18),
                        SizedBox(width: 8),
                        Text(
                          '切換店家',
                          style: TextStyle(
                            color: _textDark,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: _dividerColor, height: 1),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: restaurants.length,
                  itemBuilder: (_, i) {
                    final r = restaurants[i];
                    final selected = r.id == _current.id;
                    return InkWell(
                      onTap: () {
                        setState(() => _current = r);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        color: selected ? _surfaceLatte : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), // 稍微增加點擊範圍
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                r.images[0],
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.name,
                                    style: TextStyle(
                                      color: selected ? _accentRed : _textDark,
                                      fontSize: 18,
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    r.address,
                                    style: const TextStyle(
                                        color: _textMuted, fontSize: 15),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              const Icon(Icons.check_circle,
                                  color: _accentRed, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _current);
      },
      child: Scaffold(
        backgroundColor: _bgOffWhite,
        appBar: AppBar(
          backgroundColor: _accentRed,
          iconTheme: const IconThemeData(color: _surfaceLatte),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: _surfaceLatte,
            onPressed: () => Navigator.pop(context, _current),
          ),
          title: Text(
            _current.name,
            style: const TextStyle(
                color: _surfaceLatte,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            _ColumnToggleButton(
              current: _crossAxisCount,
              onChanged: (count) {
                setState(() {
                  _crossAxisCount = count;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // ── 上方店家資訊橫條──
            Container(
              color: _surfaceLatte,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      _current.images[0],
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _current.address,
                          style: const TextStyle(
                              color: _textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _current.time,
                          style:
                              const TextStyle(color: _textMuted, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ── Grid ──
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(3),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount, // 決定有幾欄
                  crossAxisSpacing: 3, // 欄與欄之間的水平間距
                  mainAxisSpacing: 3, // 列與列之間的垂直間距
                  childAspectRatio: 1.0,
                ),
                itemCount: _current.images.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    // 點擊事件
                    onTap: () => _openFullScreen(index), // 點擊放大
                    onLongPress: () => _showImageInfo(index), // 長按顯示圖片資訊
                    child: Hero(
                      tag: 'grid_${_current.id}_$index',
                      child: Stack(
                        fit: StackFit.expand, // 圖片填滿整個格子
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              _current.images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        // ── 底部切換店家按鈕 ──
        bottomNavigationBar: SafeArea(
          child: GestureDetector(
            onTap: _showRestaurantSwitcher,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: _surfaceLatte,
                border:
                    Border(top: BorderSide(color: _dividerColor, width: 0.5)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store, color: _accentRed, size: 18),
                  SizedBox(width: 8),
                  Text(
                    '點此切換其他店家',
                    style: TextStyle(
                      color: _accentRed,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_up, color: _accentRed, size: 18),
                ],
              ),
            ),
          ),
        ),
      ), // end PopScope
    );
  }
}

// ── 欄數切換按鈕元件 ──
class _ColumnToggleButton extends StatelessWidget {
  final int current;
  final ValueChanged<int> onChanged;

  const _ColumnToggleButton({
    required this.current,
    required this.onChanged,
  });

  static const _activeBg = Color(0xFFF3EAE1); // 奶茶色 (選中背景)
  static const _activeText = Color(0xFF610A04); // 深紅色 (選中字體)
  static const _inactiveColor = Color(0xB3F3EAE1); // 半透明奶茶色 (未選中字體/邊框)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onChanged(2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: current == 2 ? _activeBg : Colors.transparent,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(8)),
                border: Border.all(
                  color: current == 2 ? _activeBg : _inactiveColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.grid_view,
                      color: current == 2 ? _activeText : _inactiveColor,
                      size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '2',
                    style: TextStyle(
                      color: current == 2 ? _activeText : _inactiveColor,
                      fontSize: 13,
                      fontWeight:
                          current == 2 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: current == 3 ? _activeBg : Colors.transparent,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(8)),
                border: Border(
                  top: BorderSide(
                      color: current == 3 ? _activeBg : _inactiveColor),
                  right: BorderSide(
                      color: current == 3 ? _activeBg : _inactiveColor),
                  bottom: BorderSide(
                      color: current == 3 ? _activeBg : _inactiveColor),
                  left: BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.grid_on,
                      color: current == 3 ? _activeText : _inactiveColor,
                      size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '3',
                    style: TextStyle(
                      color: current == 3 ? _activeText : _inactiveColor,
                      fontSize: 13,
                      fontWeight:
                          current == 3 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 全螢幕放大檢視器 ──
class _FullScreenViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String restaurantName;
  final String heroPrefix;

  const _FullScreenViewer({
    required this.images,
    required this.initialIndex,
    required this.restaurantName,
    required this.heroPrefix,
  });

  @override
  State<_FullScreenViewer> createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<_FullScreenViewer> {
  late int _current;
  late PageController _pageCtrl;
  bool _uiVisible = true;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            // 點擊切換UI顯示
            onTap: () => setState(() => _uiVisible = !_uiVisible),
            child: PhotoViewGallery.builder(
              pageController: _pageCtrl,
              itemCount: widget.images.length,
              builder: (_, index) => PhotoViewGalleryPageOptions(
                // 圖片放大檢視設定
                imageProvider: AssetImage(widget.images[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.5,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: '${widget.heroPrefix}_$index',
                ),
              ),
              backgroundDecoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 226, 226, 1)), // 放大檢視背景色
              onPageChanged: (i) => setState(() => _current = i),
            ),
          ),
          AnimatedOpacity(
            // 上方資訊列淡入淡出
            duration: const Duration(milliseconds: 250),
            opacity: _uiVisible ? 1.0 : 0.0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(160, 0, 0, 0),
                      Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                // 避免頂部凹槽遮擋
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color.fromARGB(255, 59, 33, 6)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.restaurantName,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 59, 33, 6),
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            // 下方頁碼指示淡入淡出
            duration: const Duration(milliseconds: 250),
            opacity: _uiVisible ? 1.0 : 0.0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 36, top: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(160, 0, 0, 0),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.images.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _current == i ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _current == i
                                ? const Color(0xFFF3EAE1)
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
