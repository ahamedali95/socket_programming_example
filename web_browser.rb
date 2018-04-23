require 'socket'

class Client
  def initialize(app, username)
    @app = app
    @username = username
    self.open
  end

  def open
    window(title: "Welcome to SimpliFY", width: 250, height: 250, resizable: true) do
      background rgb(0, 157, 228)
       stack do
         "SimpliFY"
         para "Login successful!"
         flow(margin: 8) do
           @text_str = edit_line
           @send_btn = button "Go"

           @send_btn.click do
             host = @text_str.text()
             port = 80
             socket = TCPSocket.open(host,port)
             # This is the HTTP request we send to fetch a file
             request = "GET /index.html HTTP/1.0\r\n\r\n"
             socket.print(request)
             response = socket.read
             # Split response at first blank line into body
             html_doc = response.split("\r\n\r\n", 2)[1]
             para html_doc
           end
         end
       end
    end
  end
end

Shoes.app(title: "Welcome to SimpliFY", width: 250, height: 250, resizable: true) do
  background rgb(0, 157, 228)
  @users = {"a" => "m"}

  stack do
       para "Username:"
       @user_name_input = edit_line
       para "Password:"
       @password_input = edit_line
       @sign_in_btn = button "Sign in"
  end

  def is_login_successful
    @users.each do |user_name, password|
      if user_name == @user_name_input.text() && password == @password_input.text()
        return true
      end
    end

    false
  end

  @sign_in_btn.click do
    if is_login_successful
      client = Client.new(self, "ahamed")
      self.close()
    else
      @error_message = stack do
        para "Incorrect username/password"
      end
    end
  end
end
