import java.util.*;

class Mag{
  
  private final Player owner;
  private final int nrOfBullets;
  private final float w,h;
  private Bullet bullets[] = new Bullet[4];
  private Timer timer;
  
  private TimerTask timerAction = new TimerTask()
    {
        @Override
        public void run()
        {
          addBullet();
        }
    };
  
  public Mag(Player owner)
  {
    nrOfBullets = 4;
    this.owner = owner;
    for(int i = 0; i < bullets.length; i++)
    {
      bullets[i] = new Bullet(owner);
    }
    w = bullets[0].w;
    h = bullets[0].h;
    
    timer = new Timer("Reload");
    
  }
  
  public void startTimer()
  {
    //schedule(TimerTask task, long delay, long delay)
    timer.schedule(timerAction,10,2000);
  }
  
  private void addBullet()
  {
    if(bullets.length < nrOfBullets)
    {
      bullets = (Bullet[]) append(bullets,new Bullet(owner));
    }
    else
    {
      //nothing to do
    }
  }
  
  public void subtractBullet()
  {
    if(bullets.length > 0)
    {
      bullets = (Bullet[])shorten(bullets);
    }
    else
    {
      //nothing to do
    }
  }
  
  public int lenght()
  {
    return bullets.length;
  }
  
  public void drawMag()
  {
    switch(bullets.length)
    {
     case 4:
       //draw bullet 4;
       rect(owner.getX() + owner.w + w,owner.getY() + 2*h,w,h);
       //falltrough
     case 3:
       //draw bullet 3;
       rect(owner.getX() + owner.w + w,owner.getY(),w,h);
       //falltrough
     case 2:
       //draw bullet 2;
       rect(owner.getX() - 2*w,owner.getY() + 2*h,w,h);
       //falltrough
     case 1:
       //draw bullet 1;
       rect(owner.getX() - 2*w,owner.getY(),w,h);
       break;
     default:
       // nothing to display
       break;
    }
  }
}