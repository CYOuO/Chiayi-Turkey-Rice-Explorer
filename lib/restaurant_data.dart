class Restaurant {
  final String id;
  final String name;
  final String image;
  final String address;
  final String time;
  final String description;
  final String phone;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.time,
    required this.description,
    required this.phone,
  });
}


final List<Restaurant> restaurants = [
  Restaurant(
    id: '1',
    name: '民主雞肉飯',
    image: 'assets/01minzu.jpg',
    address: '嘉義市東區民族路149號',
    time: '每天10:00–20:40',
    description: '假日常常大排長龍的店，但翻桌率很高。\n這家店的火雞肉飯口味獨特，深受當地人喜愛。\n有專屬停車場。',
    phone: '05-216-2666',
  ),
  Restaurant(
    id: '2',
    name: '噴水雞肉飯-小雅旗艦店',
    image: 'assets/02pensuei.jpg',
    address: '嘉義市東區小雅路382號',
    time: '每天10:30–20:00',
    description: '著名觀光店，但其實非在地人首選。\n有專屬停車場。',
    phone: '05-222-2433',
  ),
  Restaurant(
    id: '3',
    name: '檜町雞肉飯',
    image: 'assets/03kuaiting.jpg',
    address: '嘉義市東區吳鳳北路101號',
    time: '11:00-15:00,17:00-20:00(週二、三、四公休)',
    description: '裝潢小文青，環境舒適，有焗烤雞肉飯很獨特。',
    phone: '05-222-7171',
  ),
  Restaurant(
    id: '4',
    name: '阿宏師火雞肉飯',
    image: 'assets/04hong.jpg',
    address: '嘉義市東區光華路108號',
    time: '每天10:30–20:00',
    description: '假日時期常大排長龍，多外地人，且不好停車。',
    phone: '05-223-3467',
  ),
  Restaurant(
    id: '5',
    name: '嘉義體育館姊妹火雞肉飯',
    image: 'assets/05sister.jpg',
    address: '嘉義市東區垂楊路1號',
    time: '06:00-14:00(週三公休)',
    description: '創業於西元1987年，是許多嘉義人從小吃到大的老店。',
    phone: '05-216-3755',
  ),
  Restaurant(
    id: '6',
    name: '嘉義人火雞肉飯',
    image: 'assets/06cy.jpg',
    address: '嘉義市東區垂楊路157號',
    time: '05:30–14:00',
    description: '早期是無名路邊攤起家，經營多年的老店。\n用餐時間人潮不斷，外面大馬路好停車。',
    phone: '05-223-1737',
  ),
  Restaurant(
    id: '7',
    name: '陳家美食火雞肉飯',
    image: 'assets/07chen.jpg',
    address: '嘉義市西區民族路633號',
    time: '11:00–04:00(週四公休)',
    description: '內用是拋棄式碗筷，評價不高，是某些人的一次店。',
    phone: '05-222-2748',
  ),
  Restaurant(
    id: '8',
    name: '圓環火雞大王火雞肉飯',
    image: 'assets/08king.jpg',
    address: '嘉義市東區民族路108號',
    time: '10:30–21:00',
    description: '評價感覺中規中矩，路邊有付費停車場。',
    phone: '05-277-2233',
  ),
  Restaurant(
    id: '9',
    name: '阿樓師火雞肉飯',
    image: 'assets/09lou.jpg',
    address: '嘉義市東區吳鳳北路102號',
    time: '16:00–00:00',
    description: '人氣美食須排隊，附近也有超大停車場。',
    phone: '05-228-2738',
  ),
  Restaurant(
    id: '10',
    name: '大同火雞肉飯',
    image: 'assets/10tong.jpg',
    address: '嘉義市東區民族路113號',
    time: '10:00–16:00(週二公休)',
    description: '飯粒粒分明，太晚到會蛋就沒有了，且是全熟蛋。',
    phone: '05-275-5005',
  )
];