package com.explapp.badrlegacy;

import android.app.Activity;
import android.os.Bundle;
import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.widget.*;

public class MainActivity extends Activity {
  private LinearLayout content;
  private final String[][] animals={{"🦁","أسد","Lion"},{"🐘","فيل","Elephant"},{"🐱","قطة","Cat"},{"🐶","كلب","Dog"}};
  private final String[][] food={{"🍎","تفاحة","Apple"},{"🍌","موز","Banana"},{"🍊","برتقال","Orange"},{"🥕","جزر","Carrot"}};
  private final String[][] transport={{"🚗","سيارة","Car"},{"🚌","حافلة","Bus"},{"🚆","قطار","Train"},{"✈️","طائرة","Airplane"}};
  private final String[][] colors={{"🔴","أحمر","Red"},{"🔵","أزرق","Blue"},{"🟢","أخضر","Green"},{"🟡","أصفر","Yellow"}};

  @Override public void onCreate(Bundle b){super.onCreate(b); showHome();}

  private TextView text(String s,int size){TextView v=new TextView(this);v.setText(s);v.setTextSize(size);v.setTextColor(Color.rgb(35,35,35));v.setGravity(Gravity.CENTER);v.setPadding(12,14,12,14);return v;}
  private Button button(String s){Button b=new Button(this);b.setText(s);b.setTextSize(18);return b;}

  private void showHome(){
    ScrollView sc=new ScrollView(this); content=new LinearLayout(this); content.setOrientation(LinearLayout.VERTICAL); content.setPadding(24,24,24,24); sc.addView(content);
    content.addView(text("🌟 عالم بدر 🌟",30)); content.addView(text("تعلم والعب بدون إنترنت",18));
    addCategory("🦁 غابة الحيوانات",animals); addCategory("🍎 سوق بدر",food); addCategory("🚗 مدينة المركبات",transport); addCategory("🎨 حديقة الألوان",colors);
    Button letters=button("🔤 الحروف والأرقام"); letters.setOnClickListener(v->showLetters()); content.addView(letters);
    setContentView(sc);
  }

  private void addCategory(String title,String[][] data){Button b=button(title);b.setOnClickListener(v->showList(title,data));content.addView(b);}

  private void showList(String title,String[][] data){
    LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setPadding(24,24,24,24);
    Button back=button("رجوع");back.setOnClickListener(v->showHome());root.addView(back);root.addView(text(title,28));
    for(String[] x:data){root.addView(text(x[0]+"\n"+x[1]+" - "+x[2],25));}
    ScrollView sc=new ScrollView(this);sc.addView(root);setContentView(sc);
  }

  private void showLetters(){
    LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setPadding(24,24,24,24);
    Button back=button("رجوع");back.setOnClickListener(v->showHome());root.addView(back);root.addView(text("الحروف والأرقام",28));
    root.addView(text("أ  ب  ت  ج  س  م  ن  ي",28));root.addView(text("A  B  C  D  E  F  G  H",28));root.addView(text("0  1  2  3  4  5  6  7  8  9  10",26));
    setContentView(root);
  }
}
