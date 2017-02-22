# encoding: ascii-8bit

# "ximage" challenge
# By Ron
# This program can embed arbitrary shellcode (with restrictions) into the
# data section of a bitmap image. It replaces all colours in the image with
# the closest colour consisting of "NOPs" that it's able to find. Then, it
# distributes the code in small chunks throughout.
#
# The restrictions on the shellcode are:
# - Relative jumps/calls will not work (because the code is chunked and moved
#   around)
#   The exception is call $+5 - that'll work, since it doesn't matter what the
#   next line is
# - Anything that use flags (cmp, test) will not work

METHOD_RANDOM = 1
METHOD_3D_DISTANCE = 2
METHOD_XOR_DISTANCE = 3

# On a dithered image, METHOD_RANDOM looks like garbage, but on an image
# made up of solid colours, it looks pretty neat
METHOD = METHOD_3D_DISTANCE

# I don't use these three registers for anything, so I just disable them; if
# you write code that requires them to not get messed up, change these
ESI_NOT_USED = true
EDI_NOT_USED = true
EBP_NOT_USED = true

# If this is set to 'true', the size of the image is modified to end with
# a "jmp" to our code
MAKE_WHOLE_IMAGE_RUNNABLE = true

# If this is true, the image is padded to change the size. Otherwise, the 'size'
# field is changed with no padding. Both look suspicious, but this probably
# looks more suspicious
ADD_PADDING = true

# This is repeated over and over at the end
PADDING = "This is not the flag, but keep looking at the bytes! "

# Any nops of 3 bytes or less should go here
base_nops = [
  "\x90", # nop

  "\x50\x58", # push eax / pop eax
  "\x51\x59", # push ecx / pop ecx
  "\x52\x5a", # push edx / pop edx
  "\x53\x5b", # push ebx / pop ebx
  #"\x54\x5c", # push esp / pop esp # <-- madness lies this way
  "\x55\x5d", # push ebp / pop ebp
  "\x56\x5e", # push esi / pop esi
  "\x57\x5f", # push edi / pop edi

  "\x51\x90\x59", # push ecx / nop / pop ecx
  "\x06\x07", # push es / pop es
  "\x06\x90\x07", # push es / nop / pop es

  "\x0C\x00",     # or al,0x0
  "\x80\xCB\x00", # or bl,0x0
  "\x80\xC9\x00", # or cl,0x0
  "\x80\xCA\x00", # or dl,0x0
  "\x83\xC8\x00", # or eax,byte +0x0
  "\x83\xCB\x00", # or ebx,byte +0x0
  "\x83\xC9\x00", # or ecx,byte +0x0
  "\x83\xCA\x00", # or edx,byte +0x0
  "\x83\xCE\x00", # or esi,byte +0x0
  "\x83\xCF\x00", # or edi,byte +0x0
  "\x83\xCD\x00", # or ebp,byte +0x0
  "\x83\xCC\x00", # or esp,byte +0x0

  "\x24\xFF",     # and al,0xff
  "\x80\xE3\xFF", # and bl,0xff
  "\x80\xE1\xFF", # and cl,0xff
  "\x80\xE2\xFF", # and dl,0xff

  "\x2C\x00",      # sub al,0x0
  "\x80\xEB\x00", # sub bl,0x0
  "\x80\xE9\x00", # sub cl,0x0
  "\x80\xEA\x00", # sub dl,0x0
  "\x04\x00",      # add al,0x0
  "\x80\xC3\x00", # add bl,0x0
  "\x80\xC1\x00", # add cl,0x0
  "\x80\xC2\x00", # add dl,0x0

  "\x34\x00", # xor al, 0

  "\x60\x61", # pushad / popad
  "\x60\x90\x61", # pushad / nop / popad

  "\x93\x93", # xchg eax, ebx / xchg eax, ebx

  "\x83\xC0\x00", # add eax,byte +0x0
  "\x83\xC3\x00", # add ebx,byte +0x0
  "\x83\xC1\x00", # add ecx,byte +0x0
  "\x83\xC2\x00", # add edx,byte +0x0
  "\x83\xC6\x00", # add esi,byte +0x0
  "\x83\xC7\x00", # add edi,byte +0x0
  "\x83\xC5\x00", # add ebp,byte +0x0
  "\x83\xC4\x00", # add esp,byte +0x0

  "\x83\xE8\x00", # sub eax,byte +0x0
  "\x83\xEB\x00", # sub ebx,byte +0x0
  "\x83\xE9\x00", # sub ecx,byte +0x0
  "\x83\xEA\x00", # sub edx,byte +0x0
  "\x83\xEE\x00", # sub esi,byte +0x0
  "\x83\xEF\x00", # sub edi,byte +0x0
  "\x83\xED\x00", # sub ebp,byte +0x0
  "\x83\xEC\x00", # sub esp,byte +0x0

  "\xf3\x90", # pause

  "\xC1\xE0\x00", # shl eax, 0
  "\xC1\xE3\x00", # shl ebx, 0
  "\xC1\xE1\x00", # shl ecx, 0
  "\xC1\xE2\x00", # shl edx, 0
  "\xC1\xE6\x00", # shl esi, 0
  "\xC1\xE7\x00", # shl edi, 0
  "\xC1\xE5\x00", # shl ebp, 0
  "\xC1\xE4\x00", # shl esp, 0
  "\xC1\xE8\x00", # shr eax, 0
  "\xC1\xEB\x00", # shr ebx, 0
  "\xC1\xE9\x00", # shr ecx, 0
  "\xC1\xEA\x00", # shr edx, 0
  "\xC1\xEE\x00", # shr esi, 0
  "\xC1\xEF\x00", # shr edi, 0
  "\xC1\xED\x00", # shr ebp, 0
  "\xC1\xEC\x00", # shr esp, 0
  "\xC1\xF8\x00", # sar eax, 0
  "\xC1\xFB\x00", # sar ebx, 0
  "\xC1\xF9\x00", # sar ecx, 0
  "\xC1\xFA\x00", # sar edx, 0
  "\xC1\xFE\x00", # sar esi, 0
  "\xC1\xFF\x00", # sar edi, 0
  "\xC1\xFD\x00", # sar ebp, 0
  "\xC1\xFC\x00", # sar esp, 0

  "\xeb\x00", # jmp $+2

  "\xf8", # clc - clear carry
  "\xfc", # cld - clear direction

  "\xd9\xd0", # fnop

  "\x70\x00", # jo $+2
  "\x71\x00", # jno $+2
  "\x72\x00", # jb $+2
  "\x73\x00", # jae $+2
  "\x74\x00", # jz $+2
  "\x75\x00", # jne $+2
  "\x76\x00", # jbe $+2
  "\x76\x00", # jnz $+2
  "\x77\x00", # ja $+2
  "\x78\x00", # js $+2
  "\x79\x00", # jns $+2
  "\x7a\x00", # jp $+2
  "\x7b\x00", # jnp $+2
  "\x7c\x00", # jl $+2
  "\x7d\x00", # jge $+2
  "\x7e\x00", # jle $+2
  "\x7f\x00", # jg $+2
  "\xe3\x00", # jcxz $+2 [jump short if ecx = 0]

  "\x89\xC0", # mov eax,eax
  "\x89\xDB", # mov ebx,ebx
  "\x89\xC9", # mov ecx,ecx
  "\x89\xD2", # mov edx,edx
  "\x89\xF6", # mov esi,esi
  "\x89\xFF", # mov edi,edi
  "\x89\xE4", # mov esp,esp
  "\x89\xED", # mov ebp,ebp

  "\x8D\x00", # lea eax,[eax]
  "\x8D\x1B", # lea ebx,[ebx]
  "\x8D\x09", # lea ecx,[ecx]
  "\x8D\x12", # lea edx,[edx]
  "\x8D\x36", # lea esi,[esi]
  "\x8D\x3F", # lea edi,[edi]

  "\x8D\x24\x24", # lea esp,[esp]
  "\x8D\x6D\x00", # lea ebp,[ebp+0x0]

  "\x9e", # sehf (store ah into flags)
  "\xf9", # stc
  "\xfd", # std

  "\x3B\x04\x24", # cmp eax,[esp]
  "\x3B\x1C\x24", # cmp ebx,[esp]
  "\x3B\x0C\x24", # cmp ecx,[esp]
  "\x3B\x14\x24", # cmp edx,[esp]
  "\x3B\x34\x24", # cmp esi,[esp]
  "\x3B\x3C\x24", # cmp edi,[esp]
  "\x3B\x2C\x24", # cmp ebp,[esp]
  "\x3B\x24\x24", # cmp esp,[esp]

  # Note: These ones will mess up shellcode that uses the stack to save values (eg, call $+5 / pop)
#  "\x89\x04\x24", # mov [esp],eax
#  "\x89\x1C\x24", # mov [esp],ebx
#  "\x89\x0C\x24", # mov [esp],ecx
#  "\x89\x14\x24", # mov [esp],edx
#  "\x89\x34\x24", # mov [esp],esi
#  "\x89\x3C\x24", # mov [esp],edi
#  "\x89\x2C\x24", # mov [esp],ebp
#  "\x89\x24\x24", # mov [esp],esp

#  "\x88\x04\x24", # mov [esp],al
#  "\x88\x1C\x24", # mov [esp],bl
#  "\x88\x0C\x24", # mov [esp],cl
#  "\x88\x14\x24", # mov [esp],dl
]

# Some nops that we only use if registers can be messed up
base_nops << "\x03\x34\x24" if ESI_NOT_USED # add esi,[esp]
base_nops << "\x03\x3C\x24" if EDI_NOT_USED # add edi,[esp]
base_nops << "\x03\x2C\x24" if EBP_NOT_USED # add ebp,[esp]

base_nops << "\x2B\x34\x24" if ESI_NOT_USED # sub esi,[esp]
base_nops << "\x2B\x3C\x24" if EDI_NOT_USED # sub edi,[esp]
base_nops << "\x2B\x2C\x24" if EBP_NOT_USED # sub ebp,[esp]

base_nops << "\x33\x34\x24" if ESI_NOT_USED # xor esi,[esp]
base_nops << "\x33\x3C\x24" if EDI_NOT_USED # xor edi,[esp]
base_nops << "\x33\x2C\x24" if EBP_NOT_USED # xor ebp,[esp]

base_nops << "\x0B\x34\x24" if ESI_NOT_USED # or esi,[esp]
base_nops << "\x0B\x3C\x24" if EDI_NOT_USED # or edi,[esp]
base_nops << "\x0B\x2C\x24" if EBP_NOT_USED # or ebp,[esp]

base_nops << "\x8B\x34\x24" if ESI_NOT_USED # mov esi,[esp]
base_nops << "\x8B\x3C\x24" if EDI_NOT_USED # mov edi,[esp]
base_nops << "\x8B\x2C\x24" if EBP_NOT_USED # mov ebp,[esp]


# For payloads that have a lot of possible values
0.upto(255) do |i|
  c = i.chr
  base_nops << ("\x83\xf8" + c) # cmp eax, n
  base_nops << ("\x83\xFB" + c) # cmp ebx, n
  base_nops << ("\x83\xF9" + c) # cmp ecx, n
  base_nops << ("\x83\xFA" + c) # cmp edx, n
  base_nops << ("\x83\xFE" + c) # cmp esi, n
  base_nops << ("\x83\xFF" + c) # cmp edi, n
  base_nops << ("\x83\xFD" + c) # cmp ebp, n
  base_nops << ("\x83\xFC" + c) # cmp esp, n

  base_nops << ("\x3C" + c) # cmp al, n
  base_nops << ("\x80\xFB" + c) # cmp bl, n
  base_nops << ("\x80\xF9" + c) # cmp cl, n
  base_nops << ("\x80\xFA" + c) # cmp dl, n

  base_nops << ("\xA8" + c)     # test al, n
  base_nops << ("\xF6\xC3" + c) # test bl, n
  base_nops << ("\xF6\xC1" + c) # test cl, n
  base_nops << ("\xF6\xC2" + c) # test dl, n

  base_nops << ("\x83\xc6" + c) if ESI_NOT_USED # add esi, n
  base_nops << ("\x83\xc7" + c) if EDI_NOT_USED # add edi, n
  base_nops << ("\x83\xc5" + c) if EBP_NOT_USED # add ebp, n

  base_nops << ("\x83\xef" + c) if ESI_NOT_USED # sub esi, n
  base_nops << ("\x83\xee" + c) if EDI_NOT_USED # sub edi, n
  base_nops << ("\x83\xed" + c) if EBP_NOT_USED # sub ebp, n

  base_nops << ("\x83\xf7" + c) if ESI_NOT_USED # xor esi, n
  base_nops << ("\x83\xf6" + c) if EDI_NOT_USED # xor edi, n
  base_nops << ("\x83\xf5" + c) if EBP_NOT_USED # xor ebp, n

  base_nops << ("\x83\xcf" + c) if ESI_NOT_USED # or esi, n
  base_nops << ("\x83\xce" + c) if EDI_NOT_USED # or edi, n
  base_nops << ("\x83\xcd" + c) if EBP_NOT_USED # or ebp, n

  base_nops << ("\x83\xe7" + c) if ESI_NOT_USED # and esi, n
  base_nops << ("\x83\xe6" + c) if EDI_NOT_USED # and edi, n
  base_nops << ("\x83\xe5" + c) if EBP_NOT_USED # and ebp, n

  base_nops << ("\xc1\xe7" + c) if ESI_NOT_USED # shl esi, n
  base_nops << ("\xc1\xe6" + c) if EDI_NOT_USED # shl edi, n
  base_nops << ("\xc1\xe5" + c) if EBP_NOT_USED # shl ebp, n

  base_nops << ("\xc1\xef" + c) if ESI_NOT_USED # shr esi, n
  base_nops << ("\xc1\xee" + c) if EDI_NOT_USED # shr edi, n
  base_nops << ("\xc1\xed" + c) if EBP_NOT_USED # shr ebp, n

  base_nops << ("\xc1\xff" + c) if ESI_NOT_USED # sar esi, n
  base_nops << ("\xc1\xfe" + c) if EDI_NOT_USED # sar edi, n
  base_nops << ("\xc1\xfd" + c) if EBP_NOT_USED # sar ebp, n

end

# Make a list of one-byte nops so we can use them as padding
one_byte_base_nops = []
base_nops.each do |nop|
  if(nop.length == 1)
    one_byte_base_nops << nop
  end
end

# Expand nops to all be three bytes
nops = []
base_nops.each do |nop|
  if(nop.length == 1)
    # Nops with one byte are the best, because we can combine them all with each other in various ways
    one_byte_base_nops.each do |pad1|
      nops << "#{nop}#{nop}#{pad1}"
      nops << "#{nop}#{pad1}#{nop}"
      nops << "#{pad1}#{nop}#{nop}"

      one_byte_base_nops.each do |pad2|
        nops << "#{pad1}#{pad2}#{nop}"
        nops << "#{pad1}#{nop}#{pad2}"
        nops << "#{nop}#{pad1}#{pad2}"
      end
    end
  elsif(nop.length == 2)
    # Two-byte nops can have a one-byte nop either before or after
    one_byte_base_nops.each do |pad|
      nops << "#{pad}#{nop}"
      nops << "#{nop}#{pad}"
    end
  else
    nops << nop
  end
end

puts("We have #{nops.length} nops available!")

nops.each do |nop|
  if(nop.length != 3)
    puts "Invalid nop: %s" % nop.unpack("H*")
    exit(1)
  end
end

def get_closest_nop_to(nops, pixel)

  @pixel_cache = @pixel_cache || {}

  if(@pixel_cache[pixel].nil?)
    if(METHOD == METHOD_RANDOM)
      @pixel_cache[pixel] = nops.sample
    elsif(METHOD == METHOD_3D_DISTANCE)
      best_distance = 99999999
      best_nop = "\x90\x90\x90"
      r, g, b = pixel.unpack("CCC")

      if r.nil? or g.nil? or b.nil?
        puts "something is nil?"
      end
      r = r || 0
      g = g || 0
      b = b || 0

      nops.each do |nop|
        r2, g2, b2 = nop.unpack("CCC")


        distance = (((r2 - r) ** 2) + ((g2 - g) ** 2) + ((b2 - b) ** 2))
        if(distance < best_distance)
          best_distance = distance
          best_nop = nop
        end
      end

      @pixel_cache[pixel] = best_nop

    elsif(METHOD == METHOD_XOR_DISTANCE)
      best_distance = 99999999
      best_nop = "\x90\x90\x90"
      r, g, b = pixel.unpack("CCC")

      if r.nil? or g.nil? or b.nil?
        puts "something is nil?"
      end
      r = r || 0
      g = g || 0
      b = b || 0

      nops.each do |nop|
        r2, g2, b2 = nop.unpack("CCC")
        distance = (r ^ r2) + (g ^ g2) + (b ^ b2)
        if(distance < best_distance)
          best_distance = distance
          best_nop = nop
        end
      end

      @pixel_cache[pixel] = best_nop


    else
      puts("Unknown method #{METHOD}")
      exit(1)
    end
  end

  return @pixel_cache[pixel]
end

HEADER_LENGTH = 0x36
def get_header(size, width, height)
  magic = 0x4d42 # "BM"
  reserved1 = 0
  reserved2 = 2
  data_offset = HEADER_LENGTH
  header = [magic, size, reserved1, reserved2, data_offset].pack("vVvvV")

  bitmapinfo_size = 40
  planes = 1
  bits_per_pixel = 24
  remainder = "\x00\x00\x00\x00\x20\xb8\x18\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

  puts("Writing bitmap: size = %08x, width = %08x, height = %08x" % [size, width, height])
  header += [bitmapinfo_size, width, height, planes, bits_per_pixel, remainder].pack("VVVvvA*")

  return header
end

def die(msg, exit_code = 1)
  $stderr.puts(msg)
  exit(exit_code)
end

if(ARGV.length != 3)
  puts("Usage: embed_code.rb <shellcode.asm> <input.bmp> <output.bmp>")
  exit(1)
end

# First, compile the shellcode
system("nasm -o /dev/null -l code.lst #{ARGV[0]}") || die("Couldn't assemble the shellcode: #{ARGV[0]}")

codes = []
File.open("code.lst", "r") do |file|
  file.read().split(/\n/).each do |line|
    line = line[16..-1].gsub(/ .*/, '')
    if(line.length > 0)
      line = [line].pack("H*")

      # Make sure the ling is a multiple of 3 bytes
      while((line.length % 3) != 0) do
        line = line + "\x90"
      end

      codes << line
    end
  end
end
#system("rm code.lst")

puts("The embedded code will be made up of #{codes.count} instructions with a total size of #{codes.join.length} bytes, which will take up #{codes.join.length / 3} pixels")

# This will contain the new bitmap
result = ''
size = 0
width = 0
height = 0

File.open(ARGV[1], "rb") do |bitmap|
  bitmap_file_header = bitmap.read(14)
  header, size, _, _, data_offset = bitmap_file_header.unpack("vVvvV")

  if(header != 0x4d42)
    puts("Not a BMP!")
    exit(1)
  end

  puts("Data offset: 0x%x" % data_offset)
  puts("Size: %d" % size)

  gdi_size = bitmap.read(4).unpack("V")
  if(gdi_size == 12 || gdi_size == 64)
    puts("This appears to be an OS/2 bitmap, which we don't support!")
    exit(1)
  end

  bitmapinfoheader = bitmap.read(40)
  width, height, planes, bits_per_pixel = bitmapinfoheader.unpack("VVvv")

  puts("width: #{width}")
  puts("height: #{height}")
  puts("planes: #{planes}")
  puts("bits_per_pixel: #{bits_per_pixel}")

  if(bits_per_pixel != 24)
    puts("Sorry, we only accept 24-bit encodings right now!")
    exit(1)
  end

  # Start at the beginning and read the entire header
  bitmap.pos = 0
#  result = bitmap.read(data_offset)
#  result.bytes.each do |b|
#    print("\\x%02x" % b)
#  end

  # Figure out how many bytes we have to work with
  byte_count = (size - data_offset)
  pixel_count = byte_count / 3 # 24 bits

  puts("Image contains #{byte_count} bytes, or #{pixel_count} pixels")

  # Get the actual data as an array
  bitmap.pos = data_offset
  data = bitmap.read(byte_count)

  # Break the data into pixels
  pixels = []
  data = data.chars.each_slice(3) do |slice|
    pixels << slice.join
  end

  # Make a list of which bytes are going to be replaced by codes
  code_offsets = []
  while(code_offsets.length < codes.length)
    code_offsets << rand((pixel_count - 0x16) / 4) # By dividing by 4 now and multiplying later, we reserve 12 bytes / operation
    code_offsets.uniq!
    code_offsets.sort!
  end
  code_offsets = code_offsets.map { |i| i * 4 }

  # How many pixels to ignore (for multi-pixel instructions)
  ignore_pixels = 0

  # Which code instruction we're at
  code_offset = 0

  index = 0
  pixels.each do |pixel|
    if((index % 665) == 0)
      puts("#{ARGV[1]} :: index #{index} of #{pixels.length}")
    end

    # If we're at one of our code offsets, put code there
    if(code_offsets[code_offset] == index)
      result.concat(codes[code_offset])
      ignore_pixels = (codes[code_offset].length / 3) - 1
      code_offset += 1
    else
      if(ignore_pixels > 0)
        ignore_pixels -= 1
      else
        result.concat(get_closest_nop_to(nops, pixel))
      end
    end

    index += 1
  end
end

# Pad the image to make it runnable, if we want to
if(MAKE_WHOLE_IMAGE_RUNNABLE)
  size = (result.length + HEADER_LENGTH) & 0x0000FFFF
  goal = 0xeb | ((HEADER_LENGTH - 0x04) << 8)

  difference = goal - size
  if(difference < 0)
    difference += 0x10000
  end

  if(ADD_PADDING)
    # Pad it with a funny string
    # (note: padding isn't necessary here, but it's amusing to me)
    padding = "this is not the flag you're looking for, but keep looking!! :: "
    pad = padding * (difference / padding.length)
    remaining = difference - pad.length
    pad = pad + "A" * remaining
    result = result + pad

    File.open(ARGV[2], 'wb') do |out|
      out.write(get_header(result.length + HEADER_LENGTH, width, height))
      out.write(result)
    end
  else
    File.open(ARGV[2], 'wb') do |out|
      out.write(get_header(result.length + HEADER_LENGTH + difference, width, height))
      out.write(result)
    end
  end
else
  File.open(ARGV[2], 'wb') do |out|
    out.write(get_header(result.length + HEADER_LENGTH, width, height))
    out.write(result)
  end
end
