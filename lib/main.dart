
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BadrWorldApp());
}

class BadrWorldApp extends StatelessWidget {
  const BadrWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالم بدر',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1687F2)),
      ),
      home: const BadrHome(),
    );
  }
}

class LearnItem {
  final String id;
  final String emoji;
  final String ar;
  final String en;
  final String note;
  const LearnItem(this.id, this.emoji, this.ar, this.en, this.note);
}

class Category {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<LearnItem> items;
  const Category(this.id, this.title, this.subtitle, this.emoji, this.items);
}

const categories = <Category>[
  Category('animals', 'الحيوانات', 'أسماء الحيوانات وصوت نطقها', '🦁', [
    LearnItem('lion', '🦁', 'أسد', 'Lion', 'الأسد قوي وشجاع ويعيش في الغابة.'),
    LearnItem('tiger', '🐯', 'نمر', 'Tiger', 'النمر سريع وله خطوط جميلة.'),
    LearnItem('elephant', '🐘', 'فيل', 'Elephant', 'الفيل كبير وله خرطوم طويل.'),
    LearnItem('giraffe', '🦒', 'زرافة', 'Giraffe', 'الزرافة لها رقبة طويلة.'),
    LearnItem('monkey', '🐒', 'قرد', 'Monkey', 'القرد يحب اللعب والقفز.'),
    LearnItem('bear', '🐻', 'دب', 'Bear', 'الدب هو صديقنا بدر في هذا العالم.'),
    LearnItem('rabbit', '🐰', 'أرنب', 'Rabbit', 'الأرنب سريع ويحب الجزر.'),
    LearnItem('fox', '🦊', 'ثعلب', 'Fox', 'الثعلب ذكي وهادئ.'),
    LearnItem('horse', '🐴', 'حصان', 'Horse', 'الحصان يجري بسرعة.'),
    LearnItem('cat', '🐱', 'قطة', 'Cat', 'القطة ناعمة وتحب اللعب.'),
    LearnItem('dog', '🐶', 'كلب', 'Dog', 'الكلب وفي ويحرس البيت.'),
    LearnItem('fish', '🐟', 'سمكة', 'Fish', 'السمكة تعيش في الماء.'),
  ]),
  Category('food', 'الفواكه والطعام', 'كلمات يومية سهلة', '🍎', [
    LearnItem('apple', '🍎', 'تفاحة', 'Apple', 'التفاحة فاكهة مفيدة.'),
    LearnItem('banana', '🍌', 'موز', 'Banana', 'الموز لذيذ وسهل الأكل.'),
    LearnItem('orange', '🍊', 'برتقال', 'Orange', 'البرتقال فاكهة غنية بالعصير.'),
    LearnItem('grapes', '🍇', 'عنب', 'Grapes', 'العنب حبات صغيرة جميلة.'),
    LearnItem('strawberry', '🍓', 'فراولة', 'Strawberry', 'الفراولة حمراء وحلوة.'),
    LearnItem('watermelon', '🍉', 'بطيخ', 'Watermelon', 'البطيخ منعش في الصيف.'),
    LearnItem('carrot', '🥕', 'جزر', 'Carrot', 'الجزر مفيد ومقرمش.'),
    LearnItem('corn', '🌽', 'ذرة', 'Corn', 'الذرة صفراء ولذيذة.'),
  ]),
  Category('transport', 'المواصلات', 'وسائل النقل حولنا', '🚗', [
    LearnItem('car', '🚗', 'سيارة', 'Car', 'السيارة تنقلنا على الطريق.'),
    LearnItem('bus', '🚌', 'حافلة', 'Bus', 'الحافلة تحمل ركابا كثيرين.'),
    LearnItem('truck', '🚚', 'شاحنة', 'Truck', 'الشاحنة تحمل الأشياء الثقيلة.'),
    LearnItem('train', '🚆', 'قطار', 'Train', 'القطار يسير على السكة.'),
    LearnItem('plane', '✈️', 'طائرة', 'Airplane', 'الطائرة تطير في السماء.'),
    LearnItem('ship', '🚢', 'سفينة', 'Ship', 'السفينة تسير في البحر.'),
    LearnItem('bike', '🚲', 'دراجة', 'Bicycle', 'الدراجة تحتاج إلى توازن.'),
    LearnItem('rocket', '🚀', 'صاروخ', 'Rocket', 'الصاروخ يصعد إلى الفضاء.'),
  ]),
  Category('colors', 'الألوان', 'ألوان جميلة حولنا', '🎨', [
    LearnItem('red', '🔴', 'أحمر', 'Red', 'لون جميل مثل الوردة.'),
    LearnItem('blue', '🔵', 'أزرق', 'Blue', 'لون السماء والبحر.'),
    LearnItem('green', '🟢', 'أخضر', 'Green', 'لون الأشجار والعشب.'),
    LearnItem('yellow', '🟡', 'أصفر', 'Yellow', 'لون الشمس الدافئة.'),
    LearnItem('orange', '🟠', 'برتقالي', 'Orange', 'لون مشرق ومبهج.'),
    LearnItem('purple', '🟣', 'بنفسجي', 'Purple', 'لون جميل وهادئ.'),
    LearnItem('black', '⚫', 'أسود', 'Black', 'لون الليل.'),
    LearnItem('white', '⚪', 'أبيض', 'White', 'لون السحاب.'),
  ]),
  Category('shapes', 'الأشكال', 'تعلم الأشكال الأساسية', '⭐', [
    LearnItem('circle', '●', 'دائرة', 'Circle', 'الدائرة شكل مستدير.'),
    LearnItem('square', '■', 'مربع', 'Square', 'المربع له أربعة أضلاع متساوية.'),
    LearnItem('triangle', '▲', 'مثلث', 'Triangle', 'المثلث له ثلاثة أضلاع.'),
    LearnItem('rectangle', '▰', 'مستطيل', 'Rectangle', 'المستطيل أطول من المربع.'),
    LearnItem('star', '★', 'نجمة', 'Star', 'النجمة تلمع في السماء.'),
    LearnItem('heart', '♥', 'قلب', 'Heart', 'القلب رمز المحبة.'),
  ]),
  Category('letters', 'الحروف', 'حروف عربية وإنجليزية', '🔤', [
    LearnItem('alef', 'أ', 'ألف', 'A', 'حرف ألف من الحروف العربية.'),
    LearnItem('baa', 'ب', 'باء', 'B', 'حرف باء من الحروف العربية.'),
    LearnItem('taa', 'ت', 'تاء', 'T', 'حرف تاء من الحروف العربية.'),
    LearnItem('jeem', 'ج', 'جيم', 'J', 'حرف جيم من الحروف العربية.'),
    LearnItem('seen', 'س', 'سين', 'S', 'حرف سين من الحروف العربية.'),
    LearnItem('meem', 'م', 'ميم', 'M', 'حرف ميم من الحروف العربية.'),
  ]),
];

const stories = <StoryItem>[
  StoryItem('الأرنب والسلحفاة', '🐰', [
    'كان الأرنب سريعاً جداً.',
    'كانت السلحفاة تمشي بهدوء.',
    'بدأ السباق بينهما.',
    'نام الأرنب في الطريق.',
    'واصلت السلحفاة السير.',
    'وصلت السلحفاة أولاً.',
    'تعلم الأرنب ألا يتكبر.',
  ]),
  StoryItem('الأسد والفأر', '🦁', [
    'نام الأسد تحت الشجرة.',
    'لعب فأر صغير قربه.',
    'استيقظ الأسد وأمسك الفأر.',
    'قال الفأر: سامحني يا أسد.',
    'ترك الأسد الفأر يذهب.',
    'وقع الأسد في شبكة.',
    'ساعده الفأر وقطع الشبكة.',
  ]),
  StoryItem('البذرة الصغيرة', '🌻', [
    'وجد بدر بذرة صغيرة.',
    'وضعها في التراب.',
    'سقاها كل يوم.',
    'خرجت أوراق صغيرة.',
    'كبرت وصارت زهرة جميلة.',
  ]),
  StoryItem('رحلة قطرة ماء', '💧', [
    'نزلت قطرة ماء من السحابة.',
    'سقطت على وردة عطشى.',
    'فرحت الوردة كثيراً.',
    'جرت القطرة إلى النهر.',
    'ثم عادت إلى السماء مع الشمس.',
  ]),
];

class StoryItem {
  final String title;
  final String emoji;
  final List<String> lines;
  const StoryItem(this.title, this.emoji, this.lines);
}

class BadrHome extends StatefulWidget {
  const BadrHome({super.key});

  @override
  State<BadrHome> createState() => _BadrHomeState();
}

class _BadrHomeState extends State<BadrHome> {
  int tab = 0;
  final FlutterTts tts = FlutterTts();
  int stars = 0;
  int learned = 0;
  int games = 0;
  final Set<String> learnedIds = {};

  @override
  void initState() {
    super.initState();
    _load();
    _initTts();
  }

  Future<void> _initTts() async {
    await tts.setVolume(1);
    await tts.setPitch(1);
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      stars = p.getInt('stars') ?? 0;
      games = p.getInt('games') ?? 0;
      learnedIds.addAll(p.getStringList('learnedIds') ?? const []);
      learned = learnedIds.length;
    });
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('stars', stars);
    await p.setInt('games', games);
    await p.setStringList('learnedIds', learnedIds.toList());
  }

  Future<void> speakArabic(String text, {String? note}) async {
    await tts.stop();
    await tts.setLanguage('ar-JO');
    await tts.setSpeechRate(0.48);
    await tts.setPitch(1.05);
    await tts.speak(note == null ? text : '$text. $note');
  }

  Future<void> speakEnglish(String text) async {
    await tts.stop();
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(0.40);
    await tts.setPitch(1.0);
    await tts.speak(text);
  }

  void addStar([int n = 1]) {
    setState(() => stars += n);
    _save();
    HapticFeedback.lightImpact();
  }

  void markLearned(LearnItem item) {
    if (!learnedIds.contains(item.id)) {
      setState(() {
        learnedIds.add(item.id);
        learned = learnedIds.length;
        stars += 1;
      });
      _save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('أحسنت! تعلمت ${item.ar} ⭐')),
      );
    }
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        stars: stars,
        learned: learned,
        onCategory: (c) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryScreen(
              category: c,
              speakArabic: speakArabic,
              speakEnglish: speakEnglish,
              markLearned: markLearned,
            ),
          ),
        ),
      ),
      GamesPage(
        speakArabic: speakArabic,
        speakEnglish: speakEnglish,
        onWin: () {
          setState(() {
            games += 1;
            stars += 3;
          });
          _save();
        },
      ),
      StoriesPage(speakArabic: speakArabic),
      AchievementsPage(stars: stars, learned: learned, games: games),
      ParentPage(stars: stars, learned: learned, games: games),
    ];

    return Scaffold(
      extendBody: true,
      body: BadrBackground(child: SafeArea(bottom: false, child: pages[tab])),
      bottomNavigationBar: NavigationBar(
        height: 76,
        selectedIndex: tab,
        backgroundColor: const Color(0xEE06285A),
        indicatorColor: Colors.white.withOpacity(.18),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Text('🐻', style: TextStyle(fontSize: 22)), label: 'الرئيسية'),
          NavigationDestination(icon: Text('🎮', style: TextStyle(fontSize: 22)), label: 'الألعاب'),
          NavigationDestination(icon: Text('📖', style: TextStyle(fontSize: 22)), label: 'القصص'),
          NavigationDestination(icon: Text('⭐', style: TextStyle(fontSize: 22)), label: 'إنجازاتي'),
          NavigationDestination(icon: Text('👨‍👩‍👧', style: TextStyle(fontSize: 20)), label: 'الوالدان'),
        ],
      ),
    );
  }
}

class BadrBackground extends StatelessWidget {
  final Widget child;
  const BadrBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A8CEC), Color(0xFF62D4FF), Color(0xFFB9F0A8), Color(0xFF0B4E9A)],
              ),
            ),
          ),
        ),
        Positioned(top: 40, left: 24, child: _Cloud(size: 70)),
        Positioned(top: 86, right: 26, child: _Sun()),
        Positioned(bottom: 100, right: -40, child: _Hill(size: 190)),
        Positioned(bottom: 80, left: -70, child: _Hill(size: 230)),
        child,
      ],
    );
  }
}

class _Cloud extends StatelessWidget {
  final double size;
  const _Cloud({required this.size});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .85,
      child: Icon(Icons.cloud, size: size, color: Colors.white),
    );
  }
}

class _Sun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Color(0xFFFFE66D), Color(0xFFFFA51F)]),
        boxShadow: [BoxShadow(color: Color(0x55FFB703), blurRadius: 24, spreadRadius: 8)],
      ),
    );
  }
}

class _Hill extends StatelessWidget {
  final double size;
  const _Hill({required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * .55,
      decoration: BoxDecoration(
        color: const Color(0xFF21A957).withOpacity(.75),
        borderRadius: BorderRadius.vertical(top: Radius.circular(size)),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final int stars;
  final int learned;
  final void Function(Category) onCategory;
  const HomePage({super.key, required this.stars, required this.learned, required this.onCategory});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        Row(
          children: [
            InfoPill(text: '⭐ $stars'),
            const Spacer(),
            InfoPill(text: 'تعلمت: $learned'),
          ],
        ),
        const SizedBox(height: 12),
        const HeroCard(),
        const SectionTitle(icon: '🌈', title: 'اختر عالم التعلم'),
        GridView.builder(
          itemCount: categories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05),
          itemBuilder: (_, i) => CategoryCard(category: categories[i], onTap: () => onCategory(categories[i])),
        ),
      ],
    );
  }
}

class InfoPill extends StatelessWidget {
  final String text;
  const InfoPill({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0B7FE8), Color(0xFF064F9E)]),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFD35A), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      minHeight: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFFFFD35A), width: 2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x9936C3FF), Color(0xDD06285A)],
        ),
        boxShadow: const [BoxShadow(color: Color(0x44042356), blurRadius: 30, offset: Offset(0, 18))],
      ),
      child: Stack(
        children: [
          const Positioned(left: 20, bottom: 14, child: Text('👋', style: TextStyle(fontSize: 44))),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('عالم', style: TextStyle(fontSize: 48, height: .95, fontWeight: FontWeight.w900, color: Color(0xFFFFB51F), shadows: [Shadow(offset: Offset(0, 4), color: Colors.white), Shadow(offset: Offset(0, 8), color: Color(0xFFFF9F1C))])),
                const Text('بدر', style: TextStyle(fontSize: 58, height: .95, fontWeight: FontWeight.w900, color: Color(0xFF10A8FF), shadows: [Shadow(offset: Offset(0, 4), color: Colors.white), Shadow(offset: Offset(0, 8), color: Color(0xFF014F9B))])),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6836D6)]),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white54, width: 2),
                  ),
                  child: const Text('تعلم ومرح وألعاب', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
          const Positioned(left: 20, top: 60, child: BadrBear(size: 155)),
        ],
      ),
    );
  }
}

class BadrBear extends StatelessWidget {
  final double size;
  const BadrBear({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 4, left: 16, child: _Ear(size: size * .25)),
          Positioned(top: 4, right: 16, child: _Ear(size: size * .25)),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [Color(0xFFF4BE72), Color(0xFFB96B2C), Color(0xFF7B421C)], stops: [.35, .7, 1]),
              boxShadow: [BoxShadow(color: Color(0x44000000), blurRadius: 22, offset: Offset(0, 12))],
            ),
          ),
          Positioned(top: size * .42, left: size * .33, child: const _Eye()),
          Positioned(top: size * .42, right: size * .33, child: const _Eye()),
          Positioned(top: size * .55, child: Container(width: size * .13, height: size * .09, decoration: const BoxDecoration(color: Color(0xFF10213D), borderRadius: BorderRadius.all(Radius.circular(20))))),
          Positioned(top: size * .66, child: Container(width: size * .28, height: size * .08, decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF10213D), width: size * .025)), borderRadius: BorderRadius.circular(100)))),
        ],
      ),
    );
  }
}

class _Ear extends StatelessWidget {
  final double size;
  const _Ear({required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFA65E29)));
  }
}

class _Eye extends StatelessWidget {
  const _Eye();
  @override
  Widget build(BuildContext context) {
    return Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF10213D)));
  }
}

class SectionTitle extends StatelessWidget {
  final String icon;
  final String title;
  const SectionTitle({super.key, required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF073B7A), Color(0xFF052455)]),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFD35A), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8))],
      ),
      child: Center(child: Text('$icon  $title', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900))),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  const CategoryCard({super.key, required this.category, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFFFD35A), width: 2),
            gradient: const LinearGradient(colors: [Colors.white, Color(0xFFEFF8FF)]),
            boxShadow: const [BoxShadow(color: Color(0x33042356), blurRadius: 22, offset: Offset(0, 12))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 42)),
              const SizedBox(height: 8),
              Text(category.title, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF10213D), fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(category.subtitle, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF355077), fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  final Category category;
  final Future<void> Function(String text, {String? note}) speakArabic;
  final Future<void> Function(String text) speakEnglish;
  final void Function(LearnItem item) markLearned;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.speakArabic,
    required this.speakEnglish,
    required this.markLearned,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  LearnItem get item => widget.category.items[index];

  void next() => setState(() => index = (index + 1) % widget.category.items.length);
  void prev() => setState(() => index = (index - 1 + widget.category.items.length) % widget.category.items.length);

  @override
  Widget build(BuildContext context) {
    final it = item;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BadrBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                  const Spacer(),
                  InfoPill(text: widget.category.title),
                ],
              ),
              const SizedBox(height: 12),
              ItemScene(item: it),
              const SizedBox(height: 12),
              CardShell(
                child: Column(
                  children: [
                    const Text('فصل واضح بين العربي والإنجليزي', style: TextStyle(color: Color(0xFF355077), fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: WordBox(label: 'العربية', value: it.ar, isArabic: true),
                    ),
                    const SizedBox(height: 10),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: WordBox(label: 'English', value: it.en, isArabic: false),
                    ),
                    const SizedBox(height: 12),
                    Text(it.note, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF33210A), fontSize: 17, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: SoundButton.arabic(onTap: () => widget.speakArabic(it.ar, note: it.note))),
                  const SizedBox(width: 10),
                  Expanded(child: SoundButton.english(onTap: () => widget.speakEnglish(it.en))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: PrimaryButton(text: 'السابق', icon: '◀', onTap: prev, color: const Color(0xFF0B7FE8))),
                  const SizedBox(width: 10),
                  Expanded(child: PrimaryButton(text: 'تعلمتها ⭐', icon: '✓', onTap: () => widget.markLearned(it), color: const Color(0xFF20C46B))),
                  const SizedBox(width: 10),
                  Expanded(child: PrimaryButton(text: 'التالي', icon: '▶', onTap: next, color: const Color(0xFFFF8A18))),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 76,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => setState(() => index = i),
                    child: Container(
                      width: 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: i == index ? const Color(0xFFFFD35A) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFF0B7FE8), width: 2),
                      ),
                      child: Text(widget.category.items[i].emoji, style: const TextStyle(fontSize: 34)),
                    ),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: widget.category.items.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemScene extends StatelessWidget {
  final LearnItem item;
  const ItemScene({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFFD35A), width: 2),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF8DDCFF), Color(0xFFFFF4BD), Color(0xFFA3E47A)]),
        boxShadow: const [BoxShadow(color: Color(0x44042356), blurRadius: 30, offset: Offset(0, 16))],
      ),
      child: Stack(
        children: [
          const Positioned(right: 35, top: 28, child: Text('☀️', style: TextStyle(fontSize: 46))),
          const Positioned(left: 28, top: 42, child: Text('☁️', style: TextStyle(fontSize: 42))),
          Center(child: Text(item.emoji, style: const TextStyle(fontSize: 116))),
        ],
      ),
    );
  }
}

class WordBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isArabic;
  const WordBox({super.key, required this.label, required this.value, required this.isArabic});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isArabic ? const Color(0xFFFFF7D8) : const Color(0xFFEFF7FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: isArabic ? const Color(0xFFFFBF2F) : const Color(0xFF9EEAFF), width: 2),
      ),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: isArabic ? const Color(0xFF9A5B00) : const Color(0xFF0755B2), fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(value, textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr, style: TextStyle(color: const Color(0xFF10213D), fontSize: isArabic ? 34 : 30, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class CardShell extends StatelessWidget {
  final Widget child;
  const CardShell({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFFD35A), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x33042356), blurRadius: 22, offset: Offset(0, 12))],
      ),
      child: child,
    );
  }
}

class SoundButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const SoundButton({super.key, required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});

  factory SoundButton.arabic({required VoidCallback onTap}) => SoundButton(
        title: 'صوت عربي',
        subtitle: 'ar-JO',
        icon: Icons.record_voice_over,
        color: const Color(0xFF20C46B),
        onTap: onTap,
      );

  factory SoundButton.english({required VoidCallback onTap}) => SoundButton(
        title: 'English Sound',
        subtitle: 'en-US',
        icon: Icons.volume_up,
        color: const Color(0xFF0B7FE8),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color.withOpacity(.92), color.withOpacity(.72)]),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white60, width: 2),
            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 8))],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
                  Text(subtitle, textDirection: TextDirection.ltr, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 12)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final String icon;
  final Color color;
  final VoidCallback onTap;
  const PrimaryButton({super.key, required this.text, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Colors.white54, width: 2)),
      ),
      onPressed: onTap,
      child: Text('$icon $text', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

class GamesPage extends StatefulWidget {
  final Future<void> Function(String text, {String? note}) speakArabic;
  final Future<void> Function(String text) speakEnglish;
  final VoidCallback onWin;
  const GamesPage({super.key, required this.speakArabic, required this.speakEnglish, required this.onWin});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late LearnItem question;
  late List<LearnItem> choices;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    nextQuestion();
  }

  void nextQuestion() {
    final all = categories.expand((c) => c.items).toList();
    all.shuffle();
    question = all.first;
    choices = [question, ...all.where((x) => x.id != question.id).take(3)];
    choices.shuffle();
    answered = false;
    setState(() {});
  }

  void choose(LearnItem item) {
    if (answered) return;
    setState(() => answered = true);
    if (item.id == question.id) {
      widget.onWin();
      widget.speakArabic('أحسنت');
    } else {
      widget.speakArabic('حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        const SectionTitle(icon: '🎮', title: 'لعبة الاختيار الصحيح'),
        CardShell(
          child: Column(
            children: [
              const Text('ما معنى هذه الكلمة؟', style: TextStyle(color: Color(0xFF10213D), fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Text(question.emoji, style: const TextStyle(fontSize: 86)),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(question.en, style: const TextStyle(color: Color(0xFF0755B2), fontSize: 34, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: SoundButton.english(onTap: () => widget.speakEnglish(question.en))),
                  const SizedBox(width: 10),
                  Expanded(child: SoundButton.arabic(onTap: () => widget.speakArabic(question.ar))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...choices.map((c) {
          final isCorrect = answered && c.id == question.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isCorrect ? const Color(0xFF20C46B) : Colors.white,
                foregroundColor: isCorrect ? Colors.white : const Color(0xFF10213D),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFFFD35A), width: 2)),
              ),
              onPressed: () => choose(c),
              child: Text('${c.emoji}   ${c.ar}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            ),
          );
        }),
        const SizedBox(height: 8),
        PrimaryButton(text: 'سؤال جديد', icon: '✨', color: const Color(0xFFFF8A18), onTap: nextQuestion),
      ],
    );
  }
}

class StoriesPage extends StatefulWidget {
  final Future<void> Function(String text, {String? note}) speakArabic;
  const StoriesPage({super.key, required this.speakArabic});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  int storyIndex = 0;
  int lineIndex = 0;

  @override
  Widget build(BuildContext context) {
    final story = stories[storyIndex];
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        const SectionTitle(icon: '📖', title: 'قصص بدر'),
        CardShell(
          child: Column(
            children: [
              Text(story.emoji, style: const TextStyle(fontSize: 76)),
              Text(story.title, style: const TextStyle(color: Color(0xFF10213D), fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFFFF7D8), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFFFD35A), width: 2)),
                child: Text(story.lines[lineIndex], textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF10213D), fontSize: 24, height: 1.6, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 12),
              SoundButton.arabic(onTap: () => widget.speakArabic(story.lines[lineIndex])),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: (lineIndex + 1) / story.lines.length,
                minHeight: 12,
                borderRadius: BorderRadius.circular(999),
                backgroundColor: const Color(0xFFD8ECFF),
                color: const Color(0xFF20C46B),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: PrimaryButton(text: 'السابق', icon: '◀', color: const Color(0xFF0B7FE8), onTap: () => setState(() => lineIndex = max(0, lineIndex - 1)))),
                  const SizedBox(width: 10),
                  Expanded(child: PrimaryButton(text: 'التالي', icon: '▶', color: const Color(0xFFFF8A18), onTap: () => setState(() => lineIndex = min(story.lines.length - 1, lineIndex + 1)))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text('اختر قصة', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        ...List.generate(stories.length, (i) {
          final s = stories[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: i == storyIndex ? const Color(0xFFFFD35A) : Colors.white,
                foregroundColor: const Color(0xFF10213D),
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => setState(() {
                storyIndex = i;
                lineIndex = 0;
              }),
              child: Text('${s.emoji}  ${s.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
          );
        }),
      ],
    );
  }
}

class AchievementsPage extends StatelessWidget {
  final int stars;
  final int learned;
  final int games;
  const AchievementsPage({super.key, required this.stars, required this.learned, required this.games});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        const SectionTitle(icon: '⭐', title: 'إنجازاتي'),
        CardShell(
          child: Column(
            children: [
              const BadrBear(size: 130),
              const SizedBox(height: 12),
              Text('نجومي: $stars', style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 34, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              AchievementRow(icon: '📚', title: 'الكلمات التي تعلمتها', value: '$learned'),
              AchievementRow(icon: '🎮', title: 'الألعاب الناجحة', value: '$games'),
              AchievementRow(icon: '🏆', title: 'المستوى', value: stars < 10 ? 'مبتدئ' : stars < 30 ? 'نشيط' : 'بطل بدر'),
            ],
          ),
        ),
      ],
    );
  }
}

class AchievementRow extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  const AchievementRow({super.key, required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFEFF7FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFBDE7FF), width: 2)),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(color: Color(0xFF10213D), fontWeight: FontWeight.w900))),
          Text(value, style: const TextStyle(color: Color(0xFF0755B2), fontSize: 22, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class ParentPage extends StatelessWidget {
  final int stars;
  final int learned;
  final int games;
  const ParentPage({super.key, required this.stars, required this.learned, required this.games});

  @override
  Widget build(BuildContext context) {
    final totalItems = categories.fold<int>(0, (p, c) => p + c.items.length);
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      children: [
        const SectionTitle(icon: '👨‍👩‍👧', title: 'لوحة الوالدين'),
        CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('تقرير مبسط', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF10213D), fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              AchievementRow(icon: '⭐', title: 'النجوم', value: '$stars'),
              AchievementRow(icon: '📚', title: 'الكلمات المتعلمة', value: '$learned / $totalItems'),
              AchievementRow(icon: '🎮', title: 'الألعاب الناجحة', value: '$games'),
              const SizedBox(height: 14),
              const Text(
                'ملاحظة: هذه النسخة Native Android وليست WebView. الصوت العربي والإنجليزي مفصولان بتقنيتين مختلفتين داخل التطبيق.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF355077), fontWeight: FontWeight.w800, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
