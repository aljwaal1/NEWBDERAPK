import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const BadrApp());

class BadrApp extends StatelessWidget {
  const BadrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'عالم بدر',
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox());
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0b7fe8)),
      ),
      home: const BadrHomePage(),
    );
  }
}

class LessonCategory {
  final String title;
  final String subtitle;
  final String emoji;
  final List<LessonItem> items;
  const LessonCategory(this.title, this.subtitle, this.emoji, this.items);
}

class LessonItem {
  final String ar;
  final String en;
  final String emoji;
  final String note;
  const LessonItem(this.ar, this.en, this.emoji, this.note);
}

const categories = <LessonCategory>[
  LessonCategory('الحيوانات', 'تعلم أسماء الحيوانات', '🦁', [
    LessonItem('أسد', 'Lion', '🦁', 'قوي وشجاع ويحب الغابة.'),
    LessonItem('فيل', 'Elephant', '🐘', 'كبير وله خرطوم طويل.'),
    LessonItem('زرافة', 'Giraffe', '🦒', 'لها رقبة طويلة جداً.'),
    LessonItem('قرد', 'Monkey', '🐒', 'يحب القفز واللعب.'),
    LessonItem('قطة', 'Cat', '🐱', 'ناعمة وتحب اللعب.'),
    LessonItem('كلب', 'Dog', '🐶', 'وفيّ ويحرس البيت.'),
    LessonItem('حصان', 'Horse', '🐴', 'يجري بسرعة.'),
    LessonItem('بطة', 'Duck', '🦆', 'تسبح في الماء.'),
  ]),
  LessonCategory('الفواكه والخضار', 'ألوان وأسماء مفيدة', '🍎', [
    LessonItem('تفاحة', 'Apple', '🍎', 'فاكهة حمراء أو خضراء.'),
    LessonItem('موز', 'Banana', '🍌', 'فاكهة صفراء ولذيذة.'),
    LessonItem('برتقال', 'Orange', '🍊', 'غني بالعصير.'),
    LessonItem('عنب', 'Grapes', '🍇', 'حبات صغيرة حلوة.'),
    LessonItem('جزر', 'Carrot', '🥕', 'خضار مفيد للنظر.'),
    LessonItem('طماطم', 'Tomato', '🍅', 'تستخدم في السلطة.'),
  ]),
  LessonCategory('المواصلات', 'سيارات وطائرات وسفن', '🚗', [
    LessonItem('سيارة', 'Car', '🚗', 'تسير على الطريق.'),
    LessonItem('حافلة', 'Bus', '🚌', 'تنقل عدداً كبيراً من الناس.'),
    LessonItem('قطار', 'Train', '🚆', 'يمشي على السكة.'),
    LessonItem('طائرة', 'Airplane', '✈️', 'تطير في السماء.'),
    LessonItem('سفينة', 'Ship', '🚢', 'تسير في البحر.'),
    LessonItem('دراجة', 'Bicycle', '🚲', 'تحتاج إلى توازن.'),
  ]),
  LessonCategory('الألوان', 'ألوان جميلة وواضحة', '🎨', [
    LessonItem('أحمر', 'Red', '🔴', 'لون التفاح أحياناً.'),
    LessonItem('أزرق', 'Blue', '🔵', 'لون السماء والبحر.'),
    LessonItem('أخضر', 'Green', '🟢', 'لون الأشجار.'),
    LessonItem('أصفر', 'Yellow', '🟡', 'لون الشمس.'),
    LessonItem('بنفسجي', 'Purple', '🟣', 'لون جميل وهادئ.'),
    LessonItem('برتقالي', 'Orange', '🟠', 'لون البرتقال.'),
  ]),
  LessonCategory('الأشكال', 'أشكال هندسية سهلة', '⭐', [
    LessonItem('دائرة', 'Circle', '●', 'ليس لها زوايا.'),
    LessonItem('مربع', 'Square', '■', 'له أربعة أضلاع متساوية.'),
    LessonItem('مثلث', 'Triangle', '▲', 'له ثلاثة أضلاع.'),
    LessonItem('مستطيل', 'Rectangle', '▬', 'يشبه الباب.'),
    LessonItem('نجمة', 'Star', '★', 'نراها في السماء.'),
    LessonItem('قلب', 'Heart', '♥', 'رمز المحبة.'),
  ]),
  LessonCategory('الأرقام', 'تعلم العد من 1 إلى 10', '🔢', [
    LessonItem('واحد', 'One', '1', 'رقم البداية.'),
    LessonItem('اثنان', 'Two', '2', 'واحد وواحد.'),
    LessonItem('ثلاثة', 'Three', '3', 'عدد لطيف للتدريب.'),
    LessonItem('أربعة', 'Four', '4', 'أربعة أضلاع للمربع.'),
    LessonItem('خمسة', 'Five', '5', 'أصابع اليد.'),
    LessonItem('عشرة', 'Ten', '10', 'رقم كامل وجميل.'),
  ]),
];

const stories = <List<String>>[
  ['🐰', 'الأرنب والسلحفاة', 'كان الأرنب سريعاً جداً، وكانت السلحفاة هادئة. نام الأرنب في الطريق، وواصلت السلحفاة السير حتى وصلت أولاً. تعلم الأرنب أن النشاط أهم من التكبر.'],
  ['🦁', 'الأسد والفأر', 'ساعد فأر صغير أسداً كبيراً عندما وقع في الشبكة. فرح الأسد وتعلم أن المساعدة قد تأتي من أصغر الأصدقاء.'],
  ['🌱', 'البذرة الصغيرة', 'زرع بدر بذرة في التراب وسقاها كل يوم. خرجت نبتة خضراء ثم صارت زهرة جميلة.'],
  ['☁️', 'السحابة والمطر', 'رأت سحابة أرضاً عطشى، فنزل المطر بهدوء وفرحت الزهور والأشجار.'],
  ['🐝', 'النحلة والزهور', 'طارت نحلة صغيرة بين الزهور وجمعت الرحيق، ثم عادت لتصنع عسلاً حلواً.'],
];

class BadrHomePage extends StatefulWidget {
  const BadrHomePage({super.key});

  @override
  State<BadrHomePage> createState() => _BadrHomePageState();
}

class _BadrHomePageState extends State<BadrHomePage> {
  int tab = 0;
  int stars = 0;
  int quizIndex = 0;
  String quizMessage = 'اختر الإجابة الصحيحة';

  @override
  Widget build(BuildContext context) {
    final pages = [homePage(), gamesPage(), storiesPage(), achievementsPage(), parentPage()];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff078bea), Color(0xff5ed8ff), Color(0xffbdf29c), Color(0xff0a4b94)],
          ),
        ),
        child: SafeArea(child: pages[tab]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        backgroundColor: const Color(0xff06285a),
        indicatorColor: const Color(0x33ffffff),
        destinations: const [
          NavigationDestination(icon: Text('🐻', style: TextStyle(fontSize: 24)), label: 'الرئيسية'),
          NavigationDestination(icon: Text('🎮', style: TextStyle(fontSize: 24)), label: 'الألعاب'),
          NavigationDestination(icon: Text('📖', style: TextStyle(fontSize: 24)), label: 'القصص'),
          NavigationDestination(icon: Text('⭐', style: TextStyle(fontSize: 24)), label: 'إنجازاتي'),
          NavigationDestination(icon: Text('👨‍👩‍👧', style: TextStyle(fontSize: 22)), label: 'الوالدان'),
        ],
      ),
    );
  }

  Widget pageShell(List<Widget> children) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      children: children,
    );
  }

  Widget homePage() {
    return pageShell([
      topBar(),
      heroCard(),
      titleChip('اختر قسماً للتعلم'),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (context, i) => categoryTile(categories[i]),
      ),
    ]);
  }

  Widget topBar() {
    return Row(
      children: [
        chip('⭐ $stars نجمة'),
        const Spacer(),
        chip('عالم بدر'),
      ],
    );
  }

  Widget heroCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xffffd35a), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x33042356), blurRadius: 24, offset: Offset(0, 14))],
        gradient: const LinearGradient(
          colors: [Color(0xff0b7fe8), Color(0xff06285a)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('عالم بدر', style: TextStyle(fontSize: 42, height: 1, color: Color(0xffffbf2f), fontWeight: FontWeight.w900)),
                SizedBox(height: 8),
                Text('للتعلم والمرح', style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w900)),
                SizedBox(height: 12),
                Text('تعلم • العب • اقرأ قصصاً جميلة', style: TextStyle(fontSize: 16, color: Color(0xffe8f6ff), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            width: 112,
            height: 112,
            alignment: Alignment.center,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffffc56b)),
            child: const Text('🐻', style: TextStyle(fontSize: 68)),
          ),
        ],
      ),
    );
  }

  Widget categoryTile(LessonCategory category) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryPage(category: category, onStar: addStar)));
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: tileDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 42)),
            const SizedBox(height: 8),
            Text(category.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Color(0xff10213d), fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text(category.subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Color(0xff415676), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget gamesPage() {
    final quizItems = categories.expand((e) => e.items).toList();
    final current = quizItems[quizIndex % quizItems.length];
    final options = makeOptions(current, quizItems);
    return pageShell([
      topBar(),
      titleChip('ألعاب بدر التعليمية'),
      gameHeader('🎯', 'لعبة الاختيار الصحيح', quizMessage),
      sceneBox(current.emoji, current.ar),
      const SizedBox(height: 12),
      ...options.map((o) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: bigButton(o.en, () {
              if (o.en == current.en) {
                addStar();
                setState(() {
                  quizMessage = 'أحسنت! إجابة صحيحة ⭐';
                  quizIndex++;
                });
              } else {
                setState(() => quizMessage = 'حاول مرة أخرى يا بطل');
              }
            }, alt: true),
          )),
      const SizedBox(height: 14),
      gameHeader('🧠', 'لعبة الذاكرة', 'اضغط لتبديل الرموز والتدريب على التركيز'),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(8, (i) {
          final item = quizItems[(i + quizIndex) % quizItems.length];
          return GestureDetector(
            onTap: () => setState(() => quizIndex = Random().nextInt(quizItems.length)),
            child: Container(
              width: 74,
              height: 74,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xffffd35a), width: 2)),
              child: Text(item.emoji, style: const TextStyle(fontSize: 34)),
            ),
          );
        }),
      ),
    ]);
  }

  List<LessonItem> makeOptions(LessonItem current, List<LessonItem> all) {
    final list = <LessonItem>[current];
    final random = Random(quizIndex + stars + 7);
    while (list.length < 4) {
      final item = all[random.nextInt(all.length)];
      if (!list.any((e) => e.en == item.en)) list.add(item);
    }
    list.shuffle(random);
    return list;
  }

  Widget storiesPage() {
    return pageShell([
      topBar(),
      titleChip('قصص بدر القصيرة'),
      ...stories.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: tileDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Text(s[0], style: const TextStyle(fontSize: 42)), const SizedBox(width: 10), Expanded(child: Text(s[1], style: const TextStyle(fontSize: 21, color: Color(0xff10213d), fontWeight: FontWeight.w900)))]),
                const SizedBox(height: 10),
                Text(s[2], style: const TextStyle(fontSize: 17, height: 1.6, color: Color(0xff10213d), fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: smallButton('قرأت القصة ⭐', addStar)),
              ],
            ),
          )),
    ]);
  }

  Widget achievementsPage() {
    final level = stars < 5 ? 'مبتدئ ذكي' : stars < 15 ? 'نجم التعلم' : 'بطل عالم بدر';
    return pageShell([
      topBar(),
      titleChip('إنجازاتي'),
      Container(
        padding: const EdgeInsets.all(22),
        decoration: tileDecoration(),
        child: Column(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 82)),
            Text('$stars نجمة', style: const TextStyle(fontSize: 42, color: Color(0xfff59e0b), fontWeight: FontWeight.w900)),
            Text(level, style: const TextStyle(fontSize: 24, color: Color(0xff10213d), fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text('كل إجابة صحيحة أو قصة مقروءة تضيف نجمة جديدة.', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: Color(0xff415676), fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            bigButton('إضافة نجمة تجربة', addStar),
            const SizedBox(height: 10),
            bigButton('تصفير النجوم', () => setState(() => stars = 0), danger: true),
          ],
        ),
      ),
    ]);
  }

  Widget parentPage() {
    return pageShell([
      topBar(),
      titleChip('لوحة الوالدين'),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: tileDecoration(),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ملاحظات النسخة الأولى', style: TextStyle(fontSize: 23, color: Color(0xff10213d), fontWeight: FontWeight.w900)),
            SizedBox(height: 12),
            Text('• هذه نسخة APK أصلية وليست WebView.\n• تعمل بدون إنترنت بعد التثبيت.\n• لا تحتوي مكتبات خارجية حتى يكون البناء مستقراً.\n• يمكن لاحقاً إضافة التسجيل الصوتي والنطق الحقيقي والإعلانات.', style: TextStyle(fontSize: 17, height: 1.7, color: Color(0xff10213d), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ]);
  }

  void addStar() => setState(() => stars++);

  Widget titleChip(String text) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xff06285a), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xffffd35a), width: 2)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(color: const Color(0xff064f9e), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xffffd35a), width: 2)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
    );
  }

  Widget gameHeader(String emoji, String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xee06285a), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xffffd35a), width: 2)),
      child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 38)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900)), Text(sub, style: const TextStyle(fontSize: 14, color: Color(0xffdbeafe), fontWeight: FontWeight.bold))]))]),
    );
  }

  Widget sceneBox(String emoji, String label) {
    return Container(
      height: 190,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xffffd35a), width: 2),
        gradient: const LinearGradient(colors: [Color(0xff8ddcff), Color(0xfffff4bd), Color(0xffa3e47a)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(emoji, style: const TextStyle(fontSize: 76)), Text(label, style: const TextStyle(fontSize: 30, color: Color(0xff073b7a), fontWeight: FontWeight.w900))]),
    );
  }

  Widget bigButton(String text, VoidCallback onTap, {bool alt = false, bool danger = false}) {
    final colors = danger ? const [Color(0xffff5d5d), Color(0xffd02525)] : alt ? const [Color(0xffffffff), Color(0xffeff7ff)] : const [Color(0xff0b8df7), Color(0xff0755b2)];
    final textColor = alt ? const Color(0xff0755b2) : Colors.white;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
          elevation: 5,
          backgroundColor: colors.first,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: alt ? const Color(0xffbde7ff) : Colors.white54, width: 2)),
        ),
        child: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor)),
      ),
    );
  }

  Widget smallButton(String text, VoidCallback onTap) {
    return ElevatedButton(onPressed: onTap, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff119748), foregroundColor: Colors.white), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)));
  }

  BoxDecoration tileDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(.94),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: const Color(0xffffd35a), width: 2),
      boxShadow: const [BoxShadow(color: Color(0x33042356), blurRadius: 18, offset: Offset(0, 10))],
    );
  }
}

class CategoryPage extends StatefulWidget {
  final LessonCategory category;
  final VoidCallback onStar;
  const CategoryPage({super.key, required this.category, required this.onStar});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.category.items[index];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xff078bea), Color(0xff5ed8ff), Color(0xffbdf29c)]),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              Row(children: [backButton(context), const SizedBox(width: 10), Expanded(child: Text(widget.category.title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)))]),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: const Color(0xee06285a), borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xffffd35a), width: 2)),
                child: Column(
                  children: [
                    Container(
                      height: 230,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(colors: [Color(0xff8ddcff), Color(0xfffff4bd), Color(0xffa3e47a)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                      ),
                      child: Text(item.emoji, style: const TextStyle(fontSize: 104)),
                    ),
                    const SizedBox(height: 16),
                    Text(item.ar, textAlign: TextAlign.center, style: const TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.w900)),
                    Text(item.en, textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, color: Color(0xfffff4bd), fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(color: const Color(0xfffff8dc), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xffffd35a), width: 2)),
                      child: Text(item.note, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Color(0xff33210a), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: actionButton('السابق', index == 0 ? null : () => setState(() => index--))),
                        const SizedBox(width: 10),
                        Expanded(child: actionButton('تعلمت ⭐', () { widget.onStar(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أحسنت! تمت إضافة نجمة'))); })),
                        const SizedBox(width: 10),
                        Expanded(child: actionButton('التالي', index == widget.category.items.length - 1 ? null : () => setState(() => index++))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(widget.category.items.length, (i) {
                  final selected = i == index;
                  return GestureDetector(
                    onTap: () => setState(() => index = i),
                    child: Container(
                      width: 58,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: selected ? const Color(0xffffd35a) : Colors.white, borderRadius: BorderRadius.circular(18)),
                      child: Text(widget.category.items[i].emoji, style: const TextStyle(fontSize: 26)),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget backButton(BuildContext context) => ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        label: const Text('رجوع'),
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff064f9e), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xffffd35a), width: 2))),
      );

  Widget actionButton(String text, VoidCallback? onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff0b7fe8), disabledBackgroundColor: Colors.grey.shade300, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}
