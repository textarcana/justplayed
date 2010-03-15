require 'enumerator'
require 'net/http'
require 'tagz'

module Net
  class HTTP
    def self.post_quick(url, body)
      url = URI.parse url
      req = Net::HTTP::Post.new url.path
      req.body = body

      http = Net::HTTP.new(url.host, url.port)

      res = http.start do |sess|
        sess.request req
      end

      res.body
    end
  end
end

module Encumber

  class XcodeProject
    def initialize path_for_xcode_project
      @project = path_for_xcode_project
    end

    def set_target_for_brominet
      %x{osascript<<APPLESCRIPT
tell application "Xcode"
  set myProject to active project document
  set SDK to "/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator3.0.sdk/"
  tell myProject
    set the active target to the target named "Brominet"
    set value of build setting "SDKROOT" of every build configuration of the active target to SDK
  end tell
APPLESCRIPT
 2>&1}
    end

    def start
      system("open #{@project}")
    end

    # This is a universal quit method, that leverages AppleScript to
    # close any arbitrary application.

    def quit name_for_app
      status_for_quit = %x{osascript<<APPLESCRIPT
tell application "#{name_for_app}"
  quit
end tell
APPLESCRIPT
 2>&1}

      sleep 7

      status_for_quit

    end

    def quit_all
      quit_simulator
      quit_xcode
    end

    def quit_xcode
      quit "Xcode"
    end

    def quit_simulator
      quit "iPhone Simulator"
    end

    # Attempt to launch the executable for the active target.
    # See set_target_for_brominet for configuration of targets.

    def launch_app_in_simulator
      status_for_launch = %x{osascript<<APPLESCRIPT
tell application "Xcode"
  set myProject to active project document
  launch the active executable of myProject
end tell
APPLESCRIPT
 2>&1}

      sleep 7 unless status_for_launch =~ /Unable to launch executable./

      status_for_launch

    end
  end

  class GUI
    def initialize(host='localhost', port=50000)
      @host, @port = host, port
    end

    def command(name, *params)
      raw = params.shift if params.first == :raw
      command = Tagz.tagz do
        plist_(:version => 1.0) do
          dict_ do
            key_ 'command'
            string_ name
            params.each_cons(2) do |k, v|
              key_ k
              raw ? tagz.concat(v) : string_(v)
            end
          end
        end
      end

      Net::HTTP.post_quick \
      "http://#{@host}:#{@port}/", command
    end

    def restart
      begin
        @gui.quit
      rescue EOFError
        # no-op
      end

      sleep 3

      yield if block_given?

      launch

    end

    def quit
      command 'terminateApp'
    end

    def dump
      command 'outputView'
    end

    def press(xpath)
      command 'simulateTouch', 'viewXPath', xpath
    end


    def type_in_field text, xpath
      command('setText', 
              'text',      text,
              'viewXPath', xpath)
      sleep 1
    end

    # swipe to the right
    def swipe xpath
      command('simulateSwipe',  
              'viewXPath', xpath)
    end

    # swipe to the left
    def swipe_left xpath
      command('simulateLeftSwipe',  
              'viewXPath', xpath)
    end

    def swipe_and_wait xpath
      swipe xpath
      sleep 1
    end

    def swipe_left_and_wait xpath
      swipe_left xpath
      sleep 1
    end

    def tap xpath
      press xpath
    end

    def tap_and_wait xpath
      press xpath
      sleep 1
    end

  end
end
