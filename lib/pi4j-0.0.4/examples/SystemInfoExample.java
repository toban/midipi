// START SNIPPET: system-info-snippet


/*
 * #%L
 * **********************************************************************
 * ORGANIZATION  :  Pi4J
 * PROJECT       :  Pi4J :: Java Examples
 * FILENAME      :  SystemInfoExample.java  
 * 
 * This file is part of the Pi4J project. More information about 
 * this project can be found here:  http://www.pi4j.com/
 * **********************************************************************
 * %%
 * Copyright (C) 2012 Pi4J
 * %%
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * #L%
 */


import java.io.IOException;

import com.pi4j.system.NetworkInfo;
import com.pi4j.system.SystemInfo;

/**
 * This example code demonstrates how to access a few of the system information properties and
 * network information from the Raspberry Pi.
 * 
 * @author Robert Savage
 */
public class SystemInfoExample
{
    public static void main(String[] args) throws InterruptedException, IOException
    {
        // display a few of the available system information properties
        System.out.println("----------------------------------------------------");
        System.out.println("HARDWARE INFO");
        System.out.println("----------------------------------------------------");
        System.out.println("Serial Number     :  " + SystemInfo.getSerial());
        System.out.println("CPU Revision      :  " + SystemInfo.getCpuRevision());
        System.out.println("CPU Architecture  :  " + SystemInfo.getCpuArchitecture());
        System.out.println("CPU Part          :  " + SystemInfo.getCpuPart());
        System.out.println("MIPS              :  " + SystemInfo.getBogoMIPS());
        System.out.println("Processor         :  " + SystemInfo.getProcessor());
        System.out.println("Hardware Revision :  " + SystemInfo.getRevision());
        System.out.println("Is Hard Float ABI :  " + SystemInfo.isHardFloatAbi());

        System.out.println("----------------------------------------------------");
        System.out.println("OPERATING SYSTEM INFO");
        System.out.println("----------------------------------------------------");
        System.out.println("OS Name           :  " + SystemInfo.getOsName());
        System.out.println("OS Version        :  " + SystemInfo.getOsVersion());
        System.out.println("OS Architecture   :  " + SystemInfo.getOsArch());
        
        System.out.println("----------------------------------------------------");
        System.out.println("JAVA ENVIRONMENT INFO");
        System.out.println("----------------------------------------------------");
        System.out.println("Java Vendor       :  " + SystemInfo.getJavaVendor());
        System.out.println("Java Vendor URL   :  " + SystemInfo.getJavaVendorUrl());
        System.out.println("Java Version      :  " + SystemInfo.getJavaVersion());
        System.out.println("Java VM           :  " + SystemInfo.getJavaVirtualMachine());
        System.out.println("Java Runtime      :  " + SystemInfo.getJavaRuntime());
     
        System.out.println("----------------------------------------------------");
        System.out.println("NETWORK INFO");
        System.out.println("----------------------------------------------------");
        
        // display some of the network information
        System.out.println("Hostname          :  " + NetworkInfo.getHostname());
        for (String ipAddress : NetworkInfo.getIPAddresses())
            System.out.println("IP Addresses      :  " + ipAddress);
        for (String fqdn : NetworkInfo.getFQDNs())
            System.out.println("FQDN              :  " + fqdn);
        for (String nameserver : NetworkInfo.getNameservers())
            System.out.println("Nameserver        :  " + nameserver);
    }
}
// END SNIPPET: system-info-snippet
