class Button
{
  private final PVector pos,dim;//x = w, y = h
  private final String buttonName;
  private boolean pressed = false;
  
  public Button(float x, float y,String s)
  {
    pos = new PVector(x,y);
    dim = new PVector(s.length() * width * 0.03,-(height*0.08));
    buttonName = s;
  }
  
  public void drawButton()
  {
    textSize(height*0.1);
    fill(255);
    stroke(255);
    noFill();
    rect(pos.x,pos.y,dim.x,dim.y);
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
}