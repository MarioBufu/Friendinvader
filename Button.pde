class Button
{
  private final PVector pos,dim;//x = w, y = h
  private final String buttonName;
  private String popUpText = null;
  private PVector popPos = new PVector(200,200);
  private boolean pressed = false;
  
  public Button(float x, float y,String s)
  {
    pos = new PVector(x,y);
    dim = new PVector(s.length() * width * 0.022,-(height*0.06));
    buttonName = s;
  }
  
  public void drawButton()
  {
    if(popUpText != null)
    {
      text(popUpText,popPos.x,popPos.y);
    }
    textSize(height*0.05);
    fill(255);
    stroke(255);
    noFill();
    //hitbox
    //rect(pos.x,pos.y,dim.x,dim.y);
    text(buttonName,pos.x,pos.y);
    if(pressed)
    {
      println("button "+buttonName+" clicked");
      pressed = false;
    }
  }
  
  public boolean buttonClicked(float x, float y)
  {
    if(x > pos.x && x < pos.x + dim.x && y < pos.y && y > pos.y + dim.y)
    {
      pressed = true;
      return true;
    }
    return false;
  }
  
  public void addText(String s, float xp, float yp)
  {
    popUpText = s;
    popPos.x = xp;
    popPos.y = yp;
  }
}