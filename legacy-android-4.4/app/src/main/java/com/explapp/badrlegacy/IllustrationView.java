package com.explapp.badrlegacy;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.view.View;

/** Vector-like illustrations drawn locally so Android 4.4 never depends on emoji fonts or internet images. */
public final class IllustrationView extends View {
    private final Paint p=new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Path path=new Path();
    private BadrData.Item item;
    private int worldColor=0xff1687c3;

    public IllustrationView(Context context){super(context);}
    public void setItem(BadrData.Item value){item=value;invalidate();}
    public void setWorldColor(int value){worldColor=value;item=null;invalidate();}

    @Override protected void onDraw(Canvas c){
        super.onDraw(c);
        float w=getWidth(),h=getHeight(),s=Math.min(w,h);
        p.setStyle(Paint.Style.FILL); p.setColor(0xffe9f8ff); c.drawRoundRect(new RectF(0,0,w,h),s*.09f,s*.09f,p);
        p.setColor(0xffbde8ff); c.drawCircle(w*.82f,h*.18f,s*.12f,p);
        p.setColor(0xff8bd17d); c.drawOval(new RectF(-w*.1f,h*.68f,w*1.1f,h*1.12f),p);
        if(item==null){drawWorld(c,w,h,s);return;}
        if("animals".equals(item.world))drawAnimal(c,w,h,s);
        else if("food".equals(item.world))drawFood(c,w,h,s);
        else if("transport".equals(item.world))drawTransport(c,w,h,s);
        else drawSymbol(c,w,h,s);
    }

    private void drawWorld(Canvas c,float w,float h,float s){
        p.setColor(worldColor);c.drawRoundRect(new RectF(w*.17f,h*.27f,w*.83f,h*.78f),s*.08f,s*.08f,p);
        p.setColor(0xffffd45c);c.drawRect(w*.28f,h*.12f,w*.42f,h*.38f,p);c.drawRect(w*.58f,h*.12f,w*.72f,h*.38f,p);
        p.setColor(0xffffffff);c.drawCircle(w*.35f,h*.24f,s*.035f,p);c.drawCircle(w*.65f,h*.24f,s*.035f,p);
        p.setColor(0xff69452a);c.drawRoundRect(new RectF(w*.43f,h*.52f,w*.57f,h*.78f),s*.03f,s*.03f,p);
        drawLabel(c,"عالم بدر",w*.5f,h*.92f,s*.12f,0xff173956);
    }

    private void drawAnimal(Canvas c,float w,float h,float s){
        float x=w*.5f,y=h*.48f,r=s*.25f;
        p.setColor(item.color);c.drawCircle(x,y,r,p);
        if("rabbit".equals(item.id)||"giraffe".equals(item.id)){
            c.drawOval(new RectF(x-r*.72f,y-r*1.65f,x-r*.18f,y-r*.55f),p);
            c.drawOval(new RectF(x+r*.18f,y-r*1.65f,x+r*.72f,y-r*.55f),p);
        } else {
            c.drawCircle(x-r*.72f,y-r*.68f,r*.38f,p);c.drawCircle(x+r*.72f,y-r*.68f,r*.38f,p);
        }
        if("lion".equals(item.id)){p.setStyle(Paint.Style.STROKE);p.setStrokeWidth(r*.23f);p.setColor(0xffa96824);c.drawCircle(x,y,r*1.12f,p);p.setStyle(Paint.Style.FILL);}
        p.setColor(0xffffffff);c.drawCircle(x-r*.35f,y-r*.12f,r*.16f,p);c.drawCircle(x+r*.35f,y-r*.12f,r*.16f,p);
        p.setColor(0xff263238);c.drawCircle(x-r*.35f,y-r*.10f,r*.07f,p);c.drawCircle(x+r*.35f,y-r*.10f,r*.07f,p);
        if("elephant".equals(item.id)){p.setColor(item.color);c.drawRoundRect(new RectF(x-r*.16f,y+r*.05f,x+r*.22f,y+r*1.18f),r*.18f,r*.18f,p);}
        else {p.setColor(0xff5d4037);c.drawCircle(x,y+r*.25f,r*.10f,p);p.setStyle(Paint.Style.STROKE);p.setStrokeWidth(r*.05f);c.drawArc(new RectF(x-r*.28f,y+r*.18f,x+r*.28f,y+r*.62f),15,150,false,p);p.setStyle(Paint.Style.FILL);}
        drawLabel(c,item.ar,w*.5f,h*.9f,s*.12f,0xff173956);
    }

    private void drawFood(Canvas c,float w,float h,float s){
        float x=w*.5f,y=h*.48f,r=s*.25f;p.setColor(item.color);
        if("banana".equals(item.id)){p.setStyle(Paint.Style.STROKE);p.setStrokeWidth(r*.38f);c.drawArc(new RectF(x-r,y-r,x+r,y+r),15,145,false,p);p.setStyle(Paint.Style.FILL);}
        else if("carrot".equals(item.id)){path.reset();path.moveTo(x-r*.45f,y-r*.7f);path.lineTo(x+r*.5f,y-r*.5f);path.lineTo(x,y+r*1.05f);path.close();c.drawPath(path,p);p.setColor(0xff43a047);c.drawOval(new RectF(x-r*.65f,y-r*1.05f,x,y-r*.55f),p);c.drawOval(new RectF(x,y-r*1.05f,x+r*.65f,y-r*.55f),p);}
        else if("grapes".equals(item.id)){for(int row=0;row<4;row++)for(int j=0;j<4-row;j++)c.drawCircle(x+(j-(3-row)*.5f)*r*.43f,y-r*.7f+row*r*.43f,r*.25f,p);}
        else if("corn".equals(item.id)){c.drawOval(new RectF(x-r*.5f,y-r,x+r*.5f,y+r),p);p.setColor(0xff43a047);path.reset();path.moveTo(x-r*.45f,y+r*.2f);path.lineTo(x-r*.85f,y+r);path.lineTo(x,y+r*.65f);path.close();c.drawPath(path,p);}
        else if("watermelon".equals(item.id)){c.drawCircle(x,y,r,p);p.setStyle(Paint.Style.STROKE);p.setStrokeWidth(r*.18f);p.setColor(0xff237a3d);c.drawCircle(x,y,r*.9f,p);p.setStyle(Paint.Style.FILL);}
        else {c.drawCircle(x,y,r,p);p.setColor(0xff4e8c3c);c.drawOval(new RectF(x-r*.1f,y-r*1.25f,x+r*.75f,y-r*.72f),p);}
        drawLabel(c,item.ar,w*.5f,h*.9f,s*.12f,0xff173956);
    }

    private void drawTransport(Canvas c,float w,float h,float s){
        float x=w*.5f,y=h*.52f,r=s*.25f;p.setColor(item.color);
        if("plane".equals(item.id)||"rocket".equals(item.id)){
            path.reset();path.moveTo(x,y-r*1.25f);path.lineTo(x+r*.35f,y+r*.65f);path.lineTo(x,y+r*.4f);path.lineTo(x-r*.35f,y+r*.65f);path.close();c.drawPath(path,p);
            p.setColor(0xff2781b8);path.reset();path.moveTo(x-r*.08f,y);path.lineTo(x-r,y+r*.48f);path.lineTo(x-r*.08f,y+r*.25f);path.lineTo(x+r,y+r*.48f);path.lineTo(x+r*.08f,y);path.close();c.drawPath(path,p);
        } else if("ship".equals(item.id)){
            path.reset();path.moveTo(x-r,y);path.lineTo(x+r,y);path.lineTo(x+r*.6f,y+r*.65f);path.lineTo(x-r*.65f,y+r*.65f);path.close();c.drawPath(path,p);
            p.setColor(0xffffffff);c.drawRect(x-r*.35f,y-r*.65f,x+r*.4f,y,p);
        } else if("bike".equals(item.id)){
            p.setStyle(Paint.Style.STROKE);p.setStrokeWidth(r*.12f);c.drawCircle(x-r*.7f,y+r*.45f,r*.42f,p);c.drawCircle(x+r*.7f,y+r*.45f,r*.42f,p);
            c.drawLine(x-r*.7f,y+r*.45f,x,y+r*.15f,p);c.drawLine(x,y+r*.15f,x+r*.7f,y+r*.45f,p);c.drawLine(x,y+r*.15f,x-r*.25f,y-r*.35f,p);c.drawLine(x-r*.25f,y-r*.35f,x+r*.7f,y+r*.45f,p);p.setStyle(Paint.Style.FILL);
        } else {
            c.drawRoundRect(new RectF(x-r,y-r*.65f,x+r,y+r*.5f),r*.15f,r*.15f,p);
            p.setColor(0xffd8f3ff);c.drawRect(x-r*.65f,y-r*.42f,x-r*.12f,y,p);c.drawRect(x+r*.12f,y-r*.42f,x+r*.65f,y,p);
            p.setColor(0xff30363b);c.drawCircle(x-r*.6f,y+r*.5f,r*.25f,p);c.drawCircle(x+r*.6f,y+r*.5f,r*.25f,p);
            if("ambulance".equals(item.id)){p.setColor(0xffe53935);c.drawRect(x-r*.1f,y-r*.55f,x+r*.1f,y-r*.05f,p);c.drawRect(x-r*.35f,y-r*.32f,x+r*.35f,y-r*.18f,p);}
        }
        drawLabel(c,item.ar,w*.5f,h*.9f,s*.12f,0xff173956);
    }

    private void drawSymbol(Canvas c,float w,float h,float s){
        p.setColor(item.color);
        if("circle".equals(item.id)||"red".equals(item.id)||"blue".equals(item.id)||"green".equals(item.id)||"yellow".equals(item.id))c.drawCircle(w*.5f,h*.46f,s*.25f,p);
        else if("square".equals(item.id))c.drawRect(w*.27f,h*.23f,w*.73f,h*.69f,p);
        else if("triangle".equals(item.id)){path.reset();path.moveTo(w*.5f,h*.18f);path.lineTo(w*.77f,h*.7f);path.lineTo(w*.23f,h*.7f);path.close();c.drawPath(path,p);}
        else if("star".equals(item.id))drawStar(c,w*.5f,h*.46f,s*.28f);
        else {
            String symbol=item.id.startsWith("n")?item.id.substring(1):item.en.substring(0,1).toUpperCase();
            drawLabel(c,symbol,w*.5f,h*.58f,s*.42f,item.color);
        }
        drawLabel(c,item.ar,w*.5f,h*.9f,s*.12f,0xff173956);
    }

    private void drawStar(Canvas c,float x,float y,float r){
        path.reset();for(int i=0;i<10;i++){double a=-Math.PI/2+i*Math.PI/5;float rr=i%2==0?r:r*.45f;float px=x+(float)Math.cos(a)*rr,py=y+(float)Math.sin(a)*rr;if(i==0)path.moveTo(px,py);else path.lineTo(px,py);}path.close();c.drawPath(path,p);
    }

    private void drawLabel(Canvas c,String value,float x,float baseline,float size,int color){
        p.setColor(color);p.setTextSize(size);p.setTextAlign(Paint.Align.CENTER);p.setFakeBoldText(true);c.drawText(value,x,baseline,p);p.setFakeBoldText(false);
    }
}
