import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/* ---------- この行より上には触らない！ ------------------------------------ */

final signedInUser = User(
  userId: 'user_id',
  iconUrl:
      'https://cdn.pixabay.com/photo/2020/04/07/20/36/bunny-5014814_1280.jpg',
);

final userPosts = <PostData>[
  PostData(
    user: signedInUser,
    text: '投稿本文',
    imageUrl:
        'https://cdn.pixabay.com/photo/2021/09/18/11/15/japanese-food-6634881_1280.jpg',
    createdDate: DateTime(2025, 8, 3),
    likesCount: 0,
    commentCount: 0,
  ),
];

final likedByUser = User(
  userId: 'liked_by_user_id',
  iconUrl: 'https://example.com/icon.png',
);

/* ---------- この行より下には触らない！ ------------------------------------- */

/// 投稿データのモデルクラスです。
///
/// 投稿したユーザー、投稿文章、画像URL、作成日時を管理します。
@immutable
class PostData {
  /// 投稿したユーザー
  final User user;

  /// 投稿の文章（改行は \n で）
  final String text;

  /// 投稿画像のURL
  final String imageUrl;

  /// 投稿日時
  final DateTime createdDate;

  /// いいね数（0以上）
  final int likesCount;

  /// コメント数（0以上）
  final int commentCount;

  const PostData({
    required this.user,
    required this.text,
    required this.imageUrl,
    required this.createdDate,
    required this.likesCount,
    required this.commentCount,
  });
}

/// ユーザーのモデルクラスです。
///
/// ユーザーIDとアイコン画像のURLを持ちます。
@immutable
class User {
  /// ユーザーのID
  final String userId;

  /// ユーザーのアイコン画像URL
  final String? iconUrl;

  const User({required this.userId, this.iconUrl});
}

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
  // 日付を「8月3日」形式で文字列化するヘルパー関数
  String formatDate(DateTime date) {
    return '${date.month}月${date.day}日';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InstagramAppBar(),
      body: ListView(
        children:
            userPosts.map((post) {
              return PostedItem(
                postData: post,
                likedByUser: likedByUser,
                dateString: formatDate(post.createdDate),
              );
            }).toList(),
      ),
      bottomNavigationBar: InstagramTabBar(iconUrl: userPosts[0].user.iconUrl!),
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
  final String userId;
  final String iconUrl;

  const ItemHeader({super.key, required this.userId, required this.iconUrl});

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
                userId,
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
  const ButtonMenuBar({super.key, required this.postData});

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_border),
              if (postData.likesCount > 0)
                Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text('${postData.likesCount}'),
                ),
              SizedBox(width: 8.0),
              Icon(CupertinoIcons.chat_bubble),
              if (postData.commentCount > 0)
                Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text('${postData.commentCount}'),
                ),
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
  final PostData postData;
  final User likedByUser;
  final String dateString;

  const PostedItem({
    super.key,
    required this.postData,
    required this.likedByUser,
    required this.dateString,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemHeader(
          userId: postData.user.userId,
          iconUrl: postData.user.iconUrl!,
        ),
        Image.network(
          postData.imageUrl,
          errorBuilder: (context, _, __) => Container(color: Colors.red),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonMenuBar(postData: postData),
              Text('いいね！：${likedByUser.userId}、他'),
              Text(postData.text, style: const TextStyle(color: Colors.black)),
              Text(
                dateString,
                style: const TextStyle(fontSize: 10.0, color: Colors.grey),
              ),
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
