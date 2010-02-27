## Configure

See also [Ian's instructions](http://github.com/undees/justplayed) 


First, run `iphone_cucumber_installer.sh` to get all the gems and git repos.  

That should create 2 directories called `justplayed` and `dielectric`

Then start the dielectric server,

     cd dielectric/
     ruby dielectric.rb

that should start a Sinatra server on port 4567





## Build

There are 2 build targets.  You have to build them both, in debug mode.  Order matters.

Build "Brominet" in debug mode.
THEN build the main app, also in debug mode.

At this point you should notice a new service that is running on port 50000

This service is running on the emulator.

## Test

To run the Cucumber tests, open another tab and

    cd justplayed
    cucumber

You should see the emulator walk through [Ian's tests.](http://www.oscon.com/oscon2009/public/schedule/detail/8073)

## Troubleshooting

My fork should work, but just in case, here is how I changed Ian's fork:

1. SDK version in Justplayed is wrong, but I learned that you can change it to 3.0 through the Info window in the XCODE project.
2. updated the Header Search Path so it referenced the 3.1 sdk