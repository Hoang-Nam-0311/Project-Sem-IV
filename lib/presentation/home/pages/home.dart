import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_app/common/helpers/is_dark_mode.dart';
import 'package:spotify_app/core/configs/assets/app_images.dart';
import 'package:spotify_app/core/configs/theme/app_colors.dart';
import 'package:spotify_app/presentation/home/widgets/news_artists.dart';
import 'package:spotify_app/presentation/home/widgets/news_songs.dart';
import 'package:spotify_app/presentation/home/widgets/play_list.dart';
import 'package:spotify_app/presentation/profile/pages/profile.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/assets/app_vectors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0; // chỉ số của trang hiện tại trong BottomNavigationBar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                // Hành động tìm kiếm (có thể thay thế bằng hành động cụ thể)
              },
              icon: const Icon(Icons.search), // Biểu tượng tìm kiếm
            ),
            SvgPicture.asset(
              AppVectors.logo,
              height: 40,
              width: 40,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ProfilePage(),
                  ),
                );
              },
              icon: const Icon(Icons.person), // Biểu tượng người dùng
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? _homeContent()
          : _selectedIndex == 1
              ? const Center(child: Text("The library is awaiting development"))
              : const Center(child: Text("The ranking is awaiting development")),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star), // Biểu tượng cho mục Ranking
            label: 'Ranking', // Nhãn cho mục Ranking
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey, // Màu cho các mục không được chọn
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Không có hiệu ứng nhấn
      ),
    );
  }

  Widget _homeContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _homeTopCard(),
          _tabs(),
          SizedBox(
            height: 260,
            child: TabBarView(
              controller: _tabController,
              children: const [
                NewsSongs(),
                ArtistsTab(),
                Center(child: Text('Listen to music, never podcasts')),
                // Xem thêm các nội dung khác
              ],
            ),
          ),
          const PlayList(),
          const SizedBox(height: 16.0),
          // const RankingPage(),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Image.asset(AppImages.homeArtist),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 30),
      tabs: const [
        Text(
          'Recently',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Artist',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          'Podcasts',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }
}
