import ketai.sensors.*;
import java.util.Arrays;

import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

import oscP5.*;

import android.view.*;

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
Button btButton,dodgeButton,backButton,btConnect,btDiscover,btListPaired,btStatus;


boolean menu = true;
boolean btMenu = false;
boolean btConnected = false;

int countFrame = 0;


//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

//********************************************************************


void setup()
{
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(LANDSCAPE);
  p = new Player();
  acc = new PVector(0,0);
  
  // ingame button
  backButton = new Button(0,height*0.08,"Back");
  
  //main menu
  dodgeButton = new Button(width * 0.1 ,height * 0.2,"Dodge");
  btButton = new Button(width * 0.1 ,height * 0.4,"Bluetooth");
  
  //bt menu
  btDiscover = new Button(width * 0.1 ,height * 0.2,"Discover");
  btListPaired = new Button(width * 0.1 ,height * 0.35,"List paired devices");
  btConnect = new Button(width * 0.1 ,height * 0.50,"Connect");
  btStatus = new Button(width * 0.1,height * 0.65,"Status");
  
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
      btStatus.drawButton();
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
      //isConfiguring = true;
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
        isConfiguring = false;
      }// connect
      else if(btStatus.buttonClicked(mouseX,mouseY))
      {
        btStatus.addText(getBluetoothInformation(),1000,100);
        println("\n\n"+getBluetoothInformation() + "\n");
      }// status
      else if(backButton.buttonClicked(mouseX,mouseY))
      {
        btMenu = false;
      }
    }// if(btMenu)
    else
    {
      if(dodgeButton.buttonClicked(mouseX,mouseY))
      {
        if(isConfiguring)
        {
          dodgeButton.addText("Please configure bluetooth",10,height-10);
        }
        else
        {
          dodgeButton.addText(null,0,0);
          menu = false;
          p.initMag();
        }
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
    if(p.fireBullet())
      {
      bullets = (Bullet[]) append(bullets,new Bullet(p));
      }
  }
}

public void onBackPressed() 
{
  //back button action
  //wip
  println("Back button pressed");
}

public void keyPressed()
{/*wip
  if (key == CODED) 
  {
    if (keyCode == KeyEvent.KEYCODE_BACK)
    {
      keyCode = 1;  // don't quit by default
    }
  }
  */
}

void onAccelerometerEvent(float x, float y, float z)
{
  acc.x = y;
  acc.y = x;
  acc.z = z;
}

void sendBluetoothData(float xPos)
{
  println("send xPos "+xPos+"isConfiguring "+isConfiguring+"\n");
  if (isConfiguring)
    return;
  //send data to everyone
  //  we could send to a specific device through
  //   the writeToDevice(String _devName, byte[] data)
  //  method.
  OscMessage m = new OscMessage("/remoteMouse/");
  m.add(xPos);
  
  println("name "+selectedDevice);
  //bt.writeToDeviceName(selectedDevice,m.getBytes());
  bt.broadcast(m.getBytes());
  
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  float xPos = 0.0;
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
      if (m.checkTypetag("f"))
      {
        xPos = map(m.get(0).floatValue(),0,500,0,width);
        bullets = (Bullet[]) append(bullets,new Bullet(new PVector(xPos,0),new PVector(0,height*0.02)));
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