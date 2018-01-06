import ketai.sensors.*;
import java.util.Arrays;
import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import oscP5.*;

KetaiBluetooth bt;
String selectedDevice = "";//name of connected device -> use writeToDeviceName(String,byte[])
KetaiList klist;
ArrayList<String> devicesDiscovered = new ArrayList();
boolean isConfiguring = true;

KetaiSensor sensor;
PVector acc;
Player p;
Bullet[] bullets = new Bullet[0];
//Bullet[] myBullets = new Bullet[0];
Button btButton,dodgeButton,backButton,btConnect,btDiscover,btListPaired;


boolean menu = true;
boolean btMenu = false;
boolean btConnected = false;

int countFrame = 0;

void setup()
{  
  sensor = new KetaiSensor(this);
  bt = new KetaiBluetooth(this);
  sensor.start();
  orientation(LANDSCAPE);
  p = new Player();
  acc = new PVector(0,0);
  
  // ingame button
  backButton = new Button(0,height*0.1,"Back");
  
  //main menu
  dodgeButton = new Button(width * 0.1 ,height * 0.2,"Dodge");
  btButton = new Button(width * 0.1 ,height * 0.4,"Bluetooth");
  
  //bt menu
  btDiscover = new Button(width * 0.1 ,height * 0.2,"Discover");
  btListPaired = new Button(width * 0.1 ,height * 0.4,"List paired devices");
  btConnect = new Button(width * 0.1 ,height * 0.55,"Connect");
  
}

void draw()
{
  background(78, 93, 75,200);
  if(menu)
  {
    if(btMenu)
    {
      btDiscover.drawButton();
      btListPaired.drawButton();
      btConnect.drawButton();
      backButton.drawButton();
      if(btConnected)
      {
        text("BT Connected",0,height);
      }
    }else
    {
    dodgeButton.drawButton();
    btButton.drawButton();
    }
  }// end if menu
  else
  {
    backButton.drawButton();
    p.move(acc);
    p.update();
    p.render();
    if(bullets.length > 0)
    {
      for(int i = 0;i<bullets.length;i++)
      {
        bullets[i].render();
        if(!bullets[i].hit)
          p.colisionDetect(bullets[i]);
          //sendBluetoothData((int)bullets[i].pos.x);
        if(bullets[i].hit)
        {
          bullets[i] = bullets[bullets.length-1];
          bullets[bullets.length - 1] = null;
          bullets = (Bullet[])shorten(bullets);
        } // if(bullets[i].hit)
      }// for
    }//if(bullets.length)
    
  }
    
}

void mousePressed()
{
  if(menu)
  {
    if(btMenu)
    {
      isConfiguring = true;
      if(btDiscover.buttonClicked(mouseX,mouseY))
      {
        bt.discoverDevices();
      }// discover
      else if(btConnect.buttonClicked(mouseX,mouseY))
      {
        //If we have not discovered any devices, try prior paired devices
        if (bt.getDiscoveredDeviceNames().size() > 0)
          klist = new KetaiList(this, bt.getDiscoveredDeviceNames());
        else if (bt.getPairedDeviceNames().size() > 0)
          klist = new KetaiList(this, bt.getPairedDeviceNames());
      }// connect
      else if(backButton.buttonClicked(mouseX,mouseY))
      {
        btMenu = false;
      }
    }// if(btMenu)
    else
    {
      if(dodgeButton.buttonClicked(mouseX,mouseY))
      {
        menu = false;
      }
      else if(btButton.buttonClicked(mouseX,mouseY))
      {
        bt.start();
        btMenu = true;
      }
    }
  }// if(menu)
  else if(backButton.buttonClicked(mouseX,mouseY))
  {
    menu = true;
  }
  else if(!p.dead)
  {
    bullets = (Bullet[]) append(bullets,new Bullet(p));
    sendBluetoothData((int)new Bullet(p).pos.x);
  }
  /*
  if(menu)
  {
    //rect(width * 0.1 ,height * 0.2,width * 0.14,-(height*0.075));
    if(mouseX > width * 0.1 && mouseX < width * 0.1 + width * 0.14 && mouseY < height* 0.2 && mouseY > height* 0.2 - height*0.075)
    {
      menu = false;
    }
    //rect(width * 0.1 ,height * 0.3,width * 0.14,-(height*0.075));
     if(mouseX > width * 0.1 && mouseX < width * 0.1 + width * 0.14 && mouseY < height* 0.2 && mouseY > height* 0.2 - height*0.075)
    {
      bt.discoverDevices();
      KetaiKeyboard.toggle(this);
    }
  }
  else if(!p.dead)
  {
  b = (Bullet[]) append(b,new Bullet(p));
  //b = (Bullet[]) append(b,new Bullet(new PVector(random(width),0),new PVector(0,height*0.02)));
  }
  */
}

public void keyPressed()
{
  if (key =='c')
  {
    //If we have not discovered any devices, try prior paired devices
    if (bt.getDiscoveredDeviceNames().size() > 0)
      klist = new KetaiList(this, bt.getDiscoveredDeviceNames());
    else if (bt.getPairedDeviceNames().size() > 0)
      klist = new KetaiList(this, bt.getPairedDeviceNames());
  }
}

void onAccelerometerEvent(float x, float y, float z)
{
  acc.x = y;
  acc.y = x;
  acc.z = z;
}

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

void sendBluetoothData(int xPos)
{
  println("send xPos "+xPos+"\n");
  println(getBluetoothInformation());
  if (isConfiguring)
    return;

  //send data to everyone
  //  we could send to a specific device through
  //   the writeToDevice(String _devName, byte[] data)
  //  method.
  OscMessage m = new OscMessage("/remoteMouse/");
  m.add(xPos);
  
  bt.writeToDeviceName(selectedDevice,m.getBytes());
  bt.broadcast(m.getBytes());
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  println("\n\nrecieved data from" + who + " "+data);
  if (isConfiguring)
    return;
  //KetaiOSCMessage is the same as OscMessage
  //   but allows construction by byte array
  KetaiOSCMessage m = new KetaiOSCMessage(data);
  if (m.isValid())
  {
    if (m.checkAddrPattern("/remoteMouse/"))
    {
      if (m.checkTypetag("i"))
      {
        //get xPos for enemy bullets
        //remoteMouse.x = m.get(0).intValue();
        bullets = (Bullet[]) append(bullets,new Bullet(new PVector(m.get(0).intValue(),0),new PVector(0,height*0.02)));
      }
    }
  }
}


String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Discovering: " + bt.isDiscovering() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device: devices)
  {
    btInfo+= device+"\n";
  }

  return btInfo;
}

void onKetaiListSelection(KetaiList klist)
{
  selectedDevice = klist.getSelection();
  if(bt.connectToDeviceByName(selectedDevice))
  {
    btConnected = true;
    isConfiguring = false;
  }
  else
  {
    btConnected = false;
  }
  //dispose of list for now
  klist = null;
}