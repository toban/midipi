package toban.midipi.devices;

import java.util.List;

import javax.sound.midi.InvalidMidiDataException;
import javax.sound.midi.MidiDevice;
import javax.sound.midi.MidiSystem;
import javax.sound.midi.MidiUnavailableException;
import javax.sound.midi.Receiver;
import javax.sound.midi.ShortMessage;

public class PiStep 
{
	private MidiDevice midiDev;

	public PiStep()
	{
		try {
			midiDev = MidiSystem.getSequencer();
			midiDev.open();
		} catch (MidiUnavailableException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		System.out.println(midiDev.getDeviceInfo());
		List<Receiver> recievers = midiDev.getReceivers();
		Receiver recv = null;
		
		if(recievers.size() > 0)
		{
			recv = recievers.get(0);
			ShortMessage myMsg = new ShortMessage();

			try 
			{
				myMsg.setMessage(ShortMessage.NOTE_ON, 0, 60, 93);
			} 
			catch (InvalidMidiDataException e) 
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
				long timeStamp = -1;
				recv.send(myMsg, timeStamp);
				System.out.println(myMsg.toString());
			}
		}
		else
		{
			System.out.println("no recievers");
		}
		midiDev.close();

		
	}
	
	public void run()
	{

	}
}
