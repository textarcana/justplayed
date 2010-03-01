# Cucumber functional tests for iPhone

[github.com/textarcana/justplayed](http://github.com/textarcana/justplayed)

[**Here is my fork**](http://github.com/textarcana/justplayed) of the Cucumber functional tests for iPhone that [Ian Dees presented at OSCON 2009](http://www.oscon.com/oscon2009/public/schedule/detail/8073)

And [**Here is some background**](http://del.icio.us/thefangmonster/oscon2009) on using Ruby to drive acceptance tests on the iPhone.

## Configure

See also [Ian's instructions](http://github.com/undees/justplayed) 


First get all the gems and git repos:

    sudo gem install rake rspec cucumber chronic httparty sinatra

    git clone git://github.com/undees/dielectric.git

    git clone git://github.com/textarcana/justplayed
    git clone git://github.com/undees/brominet justplayed/brominet
    git clone git://github.com/undees/cocoahttpserver justplayed/server
    git clone git://github.com/undees/asi-http-request justplayed/asi-http-request


That should create 2 directories called `justplayed` and `dielectric`

## Build

There are 2 build targets.  You have to build them both, in debug mode.  Order matters.

Build **Brominet** in debug mode.
*Then* build the main app, also in debug mode.

At this point you should notice a new service that is running on port 50000.

This service is running on the emulator.

### Troubleshooting the build

    1. clean all if any previous builds have been performed

    2. Active SDK is Simulator 3.0

    3. Active Configuration is Debug

    4. Active target/executable is JustPlayed

    5. right-click on the BROMINET build target

    6. choose to Build "Brominet" and start

    7. verify the server is running: `nc localhost 50000`


## Test

First, start the Dielectric server,

     cd dielectric/
     ruby dielectric.rb

that should start a **Sinatra** server on port 4567


Then to run the Cucumber tests, open another tab and

    cd justplayed
    cucumber

You should see the emulator walk through [Ian's tests.](http://www.youtube.com/watch?v=rZCUIcWro28&feature=player_embedded)



## Troubleshooting

My fork should work, but just in case, here is how I changed Ian's fork:

1. SDK version in Justplayed is wrong, but I learned that you can change it to 3.0 through the Info window in the XCode project.
2. updated the Header Search Path so it referenced the 3.1 sdk
