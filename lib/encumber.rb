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
      system("open #{path_for_xcode_project}")
    end

    def quit
      system(<<-HERE)
          osascript -e 'tell application "Xcode"'\\
            -e 'quit'\\
            -e 'end tell'
    HERE
    end

    def launch_app_in_simulator
      system(<<-HERE)
          osascript -e 'tell application "Xcode"'\\
            -e 'set myProject to active project document'\\
            -e 'launch the active executable of myProject'\\
            -e 'end tell'
      HERE

      sleep 7
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
