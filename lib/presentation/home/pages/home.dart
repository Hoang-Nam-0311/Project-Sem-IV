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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: BasicAppbar(
        hideBack: true,
        action: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const ProfilePage())
            );
          },
          icon: const Icon(
            Icons.person
          )
        ),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _homeTopCard(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: [
                  const NewsSongs(),
                  const ArtistsTab(),
                  Container(),
                  // Container()
                ],
              ),
            ),
            const PlayList(),
            SizedBox(height: 16.0),
            // const RankingPage(),
          ],
        ),
      ),
    );
  }

  Widget _homeTopCard(){
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                AppVectors.homeTopCard
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 60
                ),
                child: Image.asset(
                  AppImages.homeArtist
                ),
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
      padding: const EdgeInsets.symmetric(
        vertical: 30
      ),
      tabs: const [
        Text(
          'Recently',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16
          ),
        ),
        
        Text(
          'Artist',
           style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16
          ),
        ),
        Text(
          'Podcasts',
           style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16
          ),
        ),
        // Text(
        //   'Xem thêm',
        //    style: TextStyle(
        //     fontWeight: FontWeight.w500,
        //     fontSize: 16
        //   ),
        // ),
      ],
    );
  }
}