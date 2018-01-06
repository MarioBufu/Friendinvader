
class Player {
  private float w,h;
  private PVector pos,vel;
  private int health;
  private boolean dead = false;
  
  public Player()
  {
    pos = new PVector(width/2,height/2);
    vel = new PVector(0,0);
    w = width*0.1;
    h = height*0.1;
    health = 100;
  }
  
  public void update()
  {
    if(dead)
    {
      vel.mult(0);
    }
    else
    {
    pos.add(vel);
    vel.mult(0.85);
    if(pos.x > width - w)
      pos.x = width - w;
    else if(pos.x < 0)
      pos.x = 0;
    if(pos.y > height - h)
      pos.y = height - h;
    else if(pos.y < 0)
      pos.y = 0;
    }
  }
  public void move(PVector a)
  {
    if(a.x >= 0.5 || a.y >= 0.5 || a.x <= -0.5 || a.y <= -0.5)
    a.mult(height*0.0009);//speed scale with screen resolution
    vel.add(a);
  }
    
  public void render()
  {
     fill(200,0,50);
     rect(pos.x,pos.y,w,h);
     if(dead)
     {
       textSize(150);
       textAlign(CENTER,CENTER);
       text("YOU LOST !!!\nawesome particle effect",0,0,width,height);
     }
     fill(255);
     rect(pos.x,pos.y,w,map(health,0,100,0,h));
     
     
     //fill(0); 
     //text(""+health,pos.x,pos.y);
  }
  
  public void colisionDetect(Bullet b)
  {
    if(!b.myBullet && b.pos.x + w >= pos.x && b.pos.x <= pos.x+w && b.pos.y >= pos.y && b.pos.y < pos.y+h)
    {
      takeDmg(b);
      b.bulletHit();
    }
  }
  
  public void takeDmg(Bullet b)
  {
    if(health > b.damage)
      health-=b.damage;
    else
    {
      health = 0;
      dead = true;
      println("Player DEAD");
    }
  }
}