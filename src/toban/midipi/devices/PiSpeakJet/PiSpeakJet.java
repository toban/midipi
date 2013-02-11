package toban.midipi.devices.PiSpeakJet;

import java.util.List;

import toban.midipi.util.PiSerial;

import com.pi4j.io.gpio.*;
import com.pi4j.io.gpio.event.GpioPinDigitalStateChangeEvent;
import com.pi4j.io.gpio.event.GpioPinListenerDigital;

public class PiSpeakJet 
{
	final GpioController gpio = GpioFactory.getInstance();
	final GpioPinDigitalInput gateInput = gpio.provisionDigitalInputPin(
										RaspiPin.GPIO_02, 
										PinPullResistance.PULL_DOWN);
	final GpioPinDigitalOutput led1 = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_01);

	public PiSpeakJet() throws Exception
	{
		PiSerial.Init();
	}
	
	
	
	public void run()
	{
        // create and register gpio pin listener
        gateInput.addListener(new GpioPinListenerDigital()
        {
            @Override
            public void handleGpioPinDigitalStateChangeEvent(GpioPinDigitalStateChangeEvent event)
            {
                // display pin state on console
                System.out.println(" --> GPIO PIN STATE CHANGE: " + event.getPin() + " = " + event.getState());
                
                led1.blink(100,100);
            }
            
        });
        
        System.out.println(" ... complete the GPIO #02 circuit and see the listener feedback here in the console.");
        
        // keep program running until user aborts (CTRL-C)
        for (;;)
        {
            try {
				Thread.sleep(500);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
	}
}
