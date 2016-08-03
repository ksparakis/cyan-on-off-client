require 'rubygems'
require 'socket.io-client-simple'

outpin = 25
#socket = SocketIO::Client::Simple.connect 'http://localhost:3000'
def turnOn()
	`gpio write {outpin} -`
end

def turnOff()
	`gpio write {outpin} 1`
end
## connect with parameter
socket = SocketIO::Client::Simple.connect 'http://54.218.210.9:3000', :foo => "bar"

`gpio mode {outpin} out`

socket.on :connect do
  puts "connect!!!"
  puts"emitting to server add device"
  socket.emit :add_device, {:device_id => "test"}
  msg = 
  puts msg
end

socket.on :disconnect do
  puts "disconnected!!"
end

socket.on :on do
  puts "turned on"
  turnOn()
end

socket.on :off do
   puts "turned off device"
   turnOff()
end

socket.on :registered do |data|
	puts "> " + data['numDevices'].to_s
end


socket.on :error do |err|
  p err
end



puts "please input and press Enter key"
loop do
  msg = STDIN.gets.strip
  next if msg.empty?
  socket.emit :chat, {:msg => msg, :at => Time.now}
end
