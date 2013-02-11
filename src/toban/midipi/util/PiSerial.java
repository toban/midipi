package toban.midipi.util;

import com.pi4j.io.serial.*;

public class PiSerial 
{
    // create an instance of the serial communications class
    private final static Serial serial = SerialFactory.createInstance();
    
	public static void Init() throws Exception
	{
		if(!serial.isOpen())
		{
	        // open the default serial port provided on the GPIO header
	        int ret = serial.open(Serial.DEFAULT_COM_PORT, 38400);
	        
	        if (ret == -1)
	        {
	            throw new Exception();
	        }
		}
	}
	
	public static void write(String s)
	{
        serial.write(s);
	}

}
