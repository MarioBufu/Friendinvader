class Bullet
{
  private final int damage;
  private final float h,w;
  private PVector pos,dir;
  private boolean hit = false,myBullet = false;
  
  public Bullet(PVector p,PVector d)
  {
    h = height* 0.03;
    w = width * 0.03;
    damage = 10;
    myBullet = false;
    pos = p;
    dir = d;
  }
  
  public Bullet(Player p)
  {
    h = height* 0.03;
    w = width * 0.03;
    damage = 10;
    myBullet = true;
    pos = new PVector(p.pos.x + p.w - this.w,p.pos.y + this.h);
    dir = new PVector(0,-25);
  }
  
  public void update()
  {
    pos.add(dir);
  }
  
  public void render()
  {
    if(pos.y >= -5)
    {
      if(hit)
      {
        fill(128);
        dir = new PVector(0,0);
        pos = new PVector(pos.x,height/2);
      }
      else
      {
        fill(0);
      }
      rect(pos.x,pos.y,w,h);
      update();
    }
    else
    {
      sendToEnemy();
      // bulet out of screen
      hit = true;
      // if hit == true bullet will be removed from game
    }
  }
  
  public void sendToEnemy()
  {
    // send via bt pos and dir
    sendBluetoothData((int)pos.x);
  }
  
  public void bulletHit()
  {
    hit = true;
  }
 
}