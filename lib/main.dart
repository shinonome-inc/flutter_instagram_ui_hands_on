import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/* ---------- この行より上には触らない！ ------------------------------------ */

/// 自分のID（名前やニックネーム）をここに書きます。
/// 例：var id = 'tuesday12';
var id = '';

/// 投稿する文章（改行したいときは \n を使います）をここに書きます。
/// 例：var toukoubun = 'だいじょぶます\nがんばるます';
var toukoubun = '';

/// 投稿する画像のURLをここに書きます。
/// 例：var adoresu = 'https://cdn.pixabay.com/photo/2022/07/04/17/16/dove-7301617_960_720.jpg';
var adoresu = '';

/* ---------- この行より下には触らない！ ------------------------------------- */

/// ここからアプリがスタートします。
void main() {
  runApp(const MyApp());
}

/// アプリ全体の土台となる画面です。
///
/// 画面のテーマ色を青にして、
/// 最初に表示するページを [TopPage] にしています。
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Instagram UI Hands-on',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const TopPage(),
    );
  }
}

/// アプリのトップページを作るクラスです。
///
/// Instagramのような画面を作って、
/// 投稿の1つを表示します。
/// 上にAppBar（タイトルバー）、下にメニューがあります。
class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

/// トップページの中身を作る部分です。
///
/// 投稿に必要なデータを用意して、
/// 画面に表示します。
class _TopPageState extends State<TopPage> {
  var aikonUrl =
      'https://p16-sign-va.tiktokcdn.com/musically-maliva-obj/1594805258216454~c5_720x720.jpeg?x-expires=1657958400&x-signature=JpUGyh8lfsF8Rjh0AvK%2FVXHlX%2BQ%3D';
  final iineId = 'GroupTuesday12';
  final hiduke = '${DateTime.now().month}月${DateTime.now().day}日';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InstagramAppBar(),
      body: ListView(
        children: [
          PostedItem(
            id: id,
            comment: toukoubun,
            imageUrl: adoresu,
            iconUrl: aikonUrl,
            iineId: iineId,
            date: hiduke,
          ),
        ],
      ),
      bottomNavigationBar: InstagramTabBar(iconUrl: aikonUrl),
    );
  }
}

/// 丸い形のユーザーアイコンを表示するウィジェットです。
///
/// [url]に画像のアドレスを渡すと、その画像を表示します。
/// [radius]は丸の大きさ（半径）を指定します。
class UserIcon extends StatelessWidget {
  final String url;
  final double radius;

  const UserIcon({super.key, required this.url, this.radius = 16.0});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url),
      onBackgroundImageError: (_, __) => Container(color: Colors.red),
    );
  }
}

/// 画面上部のバー（AppBar）を作るクラスです。
///
/// Instagramのロゴやボタンが並んでいます。
class InstagramAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InstagramAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1.0,
      title: SizedBox(
        height: kToolbarHeight,
        width: 152.0,
        child: Row(
          children: [
            Expanded(
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Instagram_logo.svg/1200px-Instagram_logo.svg.png',
              ),
            ),
            const SizedBox(width: 4.0),
            const Icon(Icons.keyboard_arrow_down_outlined, size: 18.0),
          ],
        ),
      ),
      actions: const [
        Icon(Icons.add_box_outlined),
        SizedBox(width: 16.0),
        Icon(Icons.favorite_border),
        SizedBox(width: 16.0),
        Icon(CupertinoIcons.chat_bubble_text),
        SizedBox(width: 16.0),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// 投稿の一番上の部分を作るクラスです。
///
/// ユーザーのアイコンと名前、右端のアイコンが並びます。
class ItemHeader extends StatelessWidget {
  final String id;
  final String iconUrl;

  const ItemHeader({super.key, required this.id, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              UserIcon(url: iconUrl),
              const SizedBox(width: 8.0),
              Text(
                id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const Icon(Icons.keyboard_control),
        ],
      ),
    );
  }
}

/// いいねやコメント、シェアのボタンが並ぶ部分を作るクラスです。
class ButtonMenuBar extends StatelessWidget {
  const ButtonMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.favorite_border),
              SizedBox(width: 8.0),
              Icon(CupertinoIcons.chat_bubble),
              SizedBox(width: 8.0),
              Icon(Icons.send_outlined),
            ],
          ),
          const Icon(Icons.bookmark_border),
        ],
      ),
    );
  }
}

/// 投稿全体（ヘッダー、画像、いいねなど）をまとめて表示するクラスです。
class PostedItem extends StatelessWidget {
  final String id;
  final String comment;
  final String imageUrl;
  final String iconUrl;
  final String iineId;
  final String date;

  const PostedItem({
    super.key,
    required this.id,
    required this.comment,
    required this.imageUrl,
    required this.iconUrl,
    required this.iineId,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemHeader(id: id, iconUrl: iconUrl),
        Image.network(
          imageUrl,
          errorBuilder: (context, _, __) => Container(color: Colors.red),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ButtonMenuBar(),
              Text('いいね！：$iineId、他'),
              Text(comment, style: const TextStyle(color: Colors.black)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        UserIcon(url: iconUrl, radius: 12.0),
                        const SizedBox(width: 8.0),
                        const Text('コメントを追加…'),
                      ],
                    ),
                    SizedBox(
                      width: 72.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text('❤'), Text('🙌'), Text('⊕')],
                      ),
                    ),
                  ],
                ),
              ),
              Text(date, style: const TextStyle(fontSize: 13.0)),
            ],
          ),
        ),
      ],
    );
  }
}

/// 画面下部のメニュー（ナビゲーションバー）を作るクラスです。
///
/// ホームや検索などのボタンを配置する。
class InstagramTabBar extends StatelessWidget {
  final String iconUrl;

  const InstagramTabBar({super.key, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 28.0,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        const BottomNavigationBarItem(
          icon: Icon(Icons.ondemand_video_outlined),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: UserIcon(url: iconUrl, radius: 12.0),
          label: '',
        ),
      ],
    );
  }
}
