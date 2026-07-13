package com.explapp.badrlegacy;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public final class BadrData {
    public static final class Item {
        public final String id, world, ar, en, hint;
        public final int color;
        public Item(String id, String world, String ar, String en, String hint, int color) {
            this.id=id; this.world=world; this.ar=ar; this.en=en; this.hint=hint; this.color=color;
        }
    }

    public static final class World {
        public final String id, title, subtitle;
        public final int color;
        public final List<Item> items;
        public World(String id, String title, String subtitle, int color, Item... items) {
            this.id=id; this.title=title; this.subtitle=subtitle; this.color=color;
            this.items=Arrays.asList(items);
        }
    }

    public static final class Story {
        public final String title;
        public final String[] pages;
        public Story(String title, String... pages) { this.title=title; this.pages=pages; }
    }

    private static Item i(String id,String world,String ar,String en,String hint,int color) {
        return new Item(id,world,ar,en,hint,color);
    }

    public static final List<World> WORLDS = Arrays.asList(
        new World("animals","غابة الحيوانات","تعرّف إلى الحيوانات وصفاتها",0xff2e9d58,
            i("lion","animals","أسد","Lion","الأسد قوي وشجاع.",0xffd99a2b),
            i("tiger","animals","نمر","Tiger","النمر سريع وله خطوط جميلة.",0xffe58a2d),
            i("elephant","animals","فيل","Elephant","الفيل كبير وله خرطوم طويل.",0xff8094a7),
            i("giraffe","animals","زرافة","Giraffe","للزرافة رقبة طويلة.",0xffe5ad49),
            i("monkey","animals","قرد","Monkey","القرد يحب القفز واللعب.",0xff9a6038),
            i("rabbit","animals","أرنب","Rabbit","الأرنب سريع ويحب الجزر.",0xffe8e0d8),
            i("horse","animals","حصان","Horse","الحصان يجري بسرعة.",0xff87502e),
            i("cat","animals","قطة","Cat","القطة لطيفة وتحب اللعب.",0xffb8a18e)
        ),
        new World("food","سوق بدر","فواكه وخضار مفيدة",0xffef7b2d,
            i("apple","food","تفاحة","Apple","التفاحة فاكهة مفيدة.",0xffe44343),
            i("banana","food","موز","Banana","الموز طري ولذيذ.",0xffffd640),
            i("orange","food","برتقال","Orange","البرتقال مليء بالعصير.",0xffff8a28),
            i("grapes","food","عنب","Grapes","العنب حبات صغيرة جميلة.",0xff8d55bd),
            i("watermelon","food","بطيخ","Watermelon","البطيخ منعش في الصيف.",0xff4eaa62),
            i("carrot","food","جزر","Carrot","الجزر مقرمش ومفيد.",0xffef762f),
            i("corn","food","ذرة","Corn","الذرة صفراء ولذيذة.",0xffffcb35),
            i("strawberry","food","فراولة","Strawberry","الفراولة حمراء وجميلة.",0xffe63d53)
        ),
        new World("transport","مدينة المركبات","مركبات البر والبحر والجو",0xff1687c3,
            i("car","transport","سيارة","Car","السيارة تسير على الطريق.",0xffe34b4b),
            i("bus","transport","حافلة","Bus","الحافلة تحمل ركاباً كثيرين.",0xffffc23c),
            i("train","transport","قطار","Train","القطار يسير على السكة.",0xff397db8),
            i("plane","transport","طائرة","Airplane","الطائرة تطير في السماء.",0xffd9e7ef),
            i("ship","transport","سفينة","Ship","السفينة تسير في البحر.",0xff4a83ac),
            i("bike","transport","دراجة","Bicycle","الدراجة لها عجلتان.",0xffe85642),
            i("rocket","transport","صاروخ","Rocket","الصاروخ يصعد إلى الفضاء.",0xffd7dde5),
            i("ambulance","transport","سيارة إسعاف","Ambulance","الإسعاف يساعد المرضى.",0xfff3f4f6)
        ),
        new World("letters","جزيرة الحروف","حروف عربية وإنجليزية",0xff8358c7,
            i("alef","letters","ألف","A","ألف مثل أسد.",0xffef5350),
            i("baa","letters","باء","B","باء مثل بدر.",0xff42a5f5),
            i("taa","letters","تاء","T","تاء مثل تفاحة.",0xff66bb6a),
            i("jeem","letters","جيم","J","جيم مثل جمل.",0xffffa726),
            i("seen","letters","سين","S","سين مثل سمكة.",0xffab47bc),
            i("meem","letters","ميم","M","ميم مثل موز.",0xff26a69a),
            i("noon","letters","نون","N","نون مثل نمر.",0xffec407a),
            i("yaa","letters","ياء","Y","ياء في كلمة يد.",0xff7e57c2)
        ),
        new World("numbers","وادي الأرقام","عد من صفر إلى عشرة",0xffd8a60d,
            i("n0","numbers","صفر","Zero","لا يوجد شيء.",0xff78909c),
            i("n1","numbers","واحد","One","شيء واحد.",0xffef5350),
            i("n2","numbers","اثنان","Two","شيئان اثنان.",0xff42a5f5),
            i("n3","numbers","ثلاثة","Three","ثلاث نجوم.",0xffffa726),
            i("n4","numbers","أربعة","Four","أربع كرات.",0xff66bb6a),
            i("n5","numbers","خمسة","Five","خمس أصابع.",0xffab47bc),
            i("n6","numbers","ستة","Six","ست زهور.",0xff26a69a),
            i("n10","numbers","عشرة","Ten","عشرة أشياء.",0xffec407a)
        ),
        new World("colors","حديقة الألوان","ألوان وأشكال جميلة",0xffdb4c91,
            i("red","colors","أحمر","Red","لون التفاحة.",0xffe53935),
            i("blue","colors","أزرق","Blue","لون السماء.",0xff1e88e5),
            i("green","colors","أخضر","Green","لون العشب.",0xff43a047),
            i("yellow","colors","أصفر","Yellow","لون الشمس.",0xffffc107),
            i("circle","colors","دائرة","Circle","شكل دائري بلا زوايا.",0xff26a69a),
            i("square","colors","مربع","Square","له أربعة أضلاع متساوية.",0xff7e57c2),
            i("triangle","colors","مثلث","Triangle","له ثلاثة أضلاع.",0xffff7043),
            i("star","colors","نجمة","Star","نجمة لامعة في السماء.",0xffffb300)
        )
    );

    public static final List<Story> STORIES = Arrays.asList(
        new Story("بدر والنجمة الصغيرة","رأى بدر نجمة صغيرة تلمع فوق البيت.","قال بدر: سأتعلم كلمة جديدة حتى أصل إليها.","تعلم كلمة أسد، ثم حصل على نجمة جميلة.","فرحت النجمة وقالت: أحسنت يا بدر."),
        new Story("رحلة بدر إلى الغابة","دخل بدر الغابة بهدوء ومعه حقيبة صغيرة.","قابل الأرنب والقرد والفيل.","سمع أسماء الحيوانات بالعربي والإنجليزي.","عاد بدر سعيداً لأنه تعلم كثيراً."),
        new Story("سوق الفواكه الملون","ذهب بدر إلى سوق مليء بالألوان.","وجد تفاحة وموزة وبرتقالة.","قال بدر: Apple ثم قال تفاحة.","ابتسم البائع وأهداه نجمة تعلم."),
        new Story("القطار السريع","ركب بدر قطاراً جميلاً.","كان القطار يقول: توت توت.","تعلم بدر كلمة قطار وكلمة Train.","وصل بدر إلى مدينة المركبات."),
        new Story("حديقة الألوان","دخل بدر حديقة فيها زهور كثيرة.","رأى الأحمر والأزرق والأخضر والأصفر.","جمع الألوان في لوحة جميلة.","قال بدر: التعلم يشبه الرسم."),
        new Story("سر الحرف باء","وجد بدر حرف باء على باب صغير.","قال: باء مثل بدر وباب وبطة.","كرر الحرف بصوته الجميل.","فتح الباب ووجد لعبة جديدة.")
    );

    public static List<Item> allItems() {
        ArrayList<Item> result=new ArrayList<Item>();
        for(World world:WORLDS) result.addAll(world.items);
        return result;
    }

    public static Item find(String id) {
        for(Item item:allItems()) if(item.id.equals(id)) return item;
        return null;
    }

    private BadrData() {}
}
