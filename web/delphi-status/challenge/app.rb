require "base64"
require "sinatra"

require "openssl"

set :bind, '0.0.0.0'
set :port, 8080

MODE = "AES-256-CBC"
KEY = "6b01fc7df519fc5074c340038cbc4e0a"

def encrypt(data, key)
  iv = (0...16).map { rand(255).chr }.join
  c = OpenSSL::Cipher::Cipher.new(MODE)
  c.encrypt
  c.key = key
  c.iv = iv

  return iv + c.update(data) + c.final()
end

def decrypt(data, key)
  iv, data = data.unpack('a16a*')
  if(data.nil? or data.length < 16)
    raise(ArgumentError, "Encrypted string is too short!")
  end

  begin
    c = OpenSSL::Cipher::Cipher.new(MODE)
    c.decrypt
    c.key = key
    c.iv = iv
    return c.update(data) + c.final()
  rescue OpenSSL::Cipher::CipherError
    return nil
  end
end

def get_cmd(cmd)
  return encrypt(cmd, KEY).unpack("H*")[0]
end

get "/" do
  str = []
  str << "<script type='text/javascript'>"
  str << "  function go(cmd) {"
  str << "    document.getElementById('cmd').src = cmd;"
  str << "  }"
  str << "</script>"
  str << "<p>What would you like to do?</p>"
  str << "<ul>"
  str << "<li><a href='#' onClick=go('/execute/#{get_cmd('netstat -an')}')>netstat</a>"
  str << "<li><a href='#' onClick=go('/execute/#{get_cmd('ps aux')}')>ps</a>"
  str << "<li><a href='#' onClick=go('/execute/#{get_cmd('echo "This is a longer string that I want to use to test multiple-block patterns"')}')>echo something</a>"
  str << "</ul>"
  str << "<iframe id='cmd' src='about:blank' />"

  return str.join("\n")
end

get "/execute/:cmd" do |cmd|
  begin
    cmd = decrypt([cmd].pack("H*"), KEY)

    if(cmd.nil?)
      return "Failed to decrypt!"
    else
      puts('RUNNING => %s' % cmd)
      return '<pre>' + `#{cmd}` + '</pre>'
    end
  rescue Exception => e
    return('<pre>Error: %s</pre>' % e.to_s)
  end
end