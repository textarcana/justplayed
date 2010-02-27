## Configure

First, run the shell script included here.  That should create 2 directories called `justplayed` and `dielectric`

Start the dielectric server,

     cd dielectric/
     ruby dielectric.rb

that should start a Sinatra server on port 4567

## Build

There are 2 build targets.  You have to build them both.  Order matters.
Build "Brominet" in debug mode.
THEN build the main app, also in debug mode.

At this point you should notice a new service that is running on port 50000

This service is running on the emulator.  It is a tiny Ruby Web service called Encumber, running on CocoaHTTPServer.

## Test

To run the Cucumber tests, open another tab and

    cd 

## Troubleshooting

My fork should work, but just in case, here is how I changed Ian's fork:

1. SDK version in Justplayed is wrong, but I learned that you can change it to 3.0 through the Info window in the XCODE project.