require 'unimidi' 
require File.join(File.dirname(__FILE__), 'io_listener.rb')

#
# midi listener uses UniMidi to listen for messages and tell midipi what to do
class ADCVListener
	attr_accessor :midipi, :channel
	
	def initialize(midipi, channel)
	
		# todo, either programchange or midichannel
		$log.info("adcv listener on %s" % channel)
		@midipi = midipi
		@channel = channel
	end
        
        def poll()
                #$log.info("polling adcv")
        end
	
end

DEBUG = true

class MCP3008 < ADCVListener


        # read SPI data from MCP3008 chip, 8 possible adc's (0 thru 7)
        def readadc(adcnum, clockpin, mosipin, misopin, cspin)


          if ((adcnum > 7) || (adcnum < 0))
                  return -1
          end
                  
          @midipi.gpio.write(cspin, HIGH)

          @midipi.gpio.write(clockpin, LOW)  # start clock low
          @midipi.gpio.write(cspin, LOW)     # bring CS low

          commandout = adcnum
          commandout |= 0x18  # start bit + single-ended bit
          commandout <<= 3    # we only need to send 5 bits here

          for i in 0..4

                  if (commandout & 0x80)
                          @midipi.gpio.write(mosipin, HIGH)
                  else
                          @midipi.gpio.write(mosipin, LOW)
                  end
                  
                  commandout <<= 1
                  @midipi.gpio.write(clockpin, HIGH)
                  @midipi.gpio.write(clockpin, LOW)
          end

          adcout = 0

          # read in one empty bit, one null bit and 10 ADC bits
          for i in 0..141

                  @midipi.gpio.write(clockpin, HIGH)
                  @midipi.gpio.write(clockpin, LOW)
                  adcout <<= 1
                  
                  if (@midipi.gpio.read(misopin))
                          adcout |= 0x1
                  end
          end

          @midipi.gpio.write(cspin, HIGH)

          adcout >>= 1       # first bit is 'null' so drop it
          return adcout

        end
        
        def poll()
                # change these as desired - they're the pins connected from the
                # SPI port on the ADC to the Cobbler
                spi_clk = 1 #18
                spi_miso = 4 #23
                spi_mosi = 5 #24
                spi_cs = 6 #25

                # set up the SPI interface pins
                #@midipi.gpio.setup(spi_mosi, GPIO.OUT)
                #@midipi.gpio.setup(spi_miso, GPIO.IN)
                #@midipi.gpio.setup(spi_clk, GPIO.OUT)
                #@midipi.gpio.setup(spi_cs, GPIO.OUT)

                # 10k trim pot connected to adc #0
                potentiometer_adc = 0

                last_read = 0       # this keeps track of the last potentiometer value
                tolerance = 5       # to keep from being jittery we'll only change
                
                # volume when the pot has moved more than 5 'counts'
                
                # we'll assume that the pot didn't move
                trim_pot_changed = false

                # read the analog pin
                trim_pot = readadc(potentiometer_adc, spi_clk, spi_mosi, spi_miso, spi_cs)
                # how much has it changed since the last read?
                pot_adjust = (trim_pot - last_read).abs

                if DEBUG
                        #$log.info("trim_pot: %s" % trim_pot)
                        #$log.info("pot_adjust: %s" % pot_adjust)
                        #$log.info("last_read" % last_read)
                end

                if (pot_adjust > tolerance)
                        trim_pot_changed = true
                end

                if DEBUG
                        #$log.info("trim_pot_changed %s" % trim_pot_changed)
                end

                if ( trim_pot_changed )
                        set_volume = trim_pot / 10.24           # convert 10bit adc0 (0-1024) trim pot read into 0-100 volume level
                        set_volume = (set_volume).round          # round out decimal value
                        set_volume = set_volume            # cast volume as integer

                        if DEBUG
                                $log.info("set_volume %s" % set_volume)
                        end

                        # save the potentiometer reading for the next loop
                        last_read = trim_pot
                end
        end

end
