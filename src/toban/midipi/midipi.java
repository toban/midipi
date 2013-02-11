/**
 * 
 */
package toban.midipi;
import toban.midipi.devices.*;
import toban.midipi.devices.PiSpeakJet.PiSpeakJet;

/**
 * @author tobias
 *
 */
public class midipi {

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		// TODO Auto-generated method stub
		
		try {
			PiSpeakJet sq;
			sq = new PiSpeakJet();
			sq.run();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

	}

}
