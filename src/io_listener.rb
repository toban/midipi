#! /usr/bin/ruby

class IOListener
        
        def poll()
                $log.info("IOListener on %s" % channel)
        end
end
