if(ARGV.length != 2)
  puts("Usage: extract_code.rb <input.bmp> <output.bin>")
  exit(1)
end

# This will contain the new bitmap
result = ""

File.open(ARGV[0], "rb") do |bitmap|
  bitmap_file_header = bitmap.read(14)
  header, size, reserved1, reserved2, data_offset = bitmap_file_header.unpack("vVvvV")

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

  # Figure out how many bytes we have to work with
  byte_count = (size - data_offset)
  pixel_count = byte_count / 3 # 24 bits

  puts("Image contains #{byte_count} bytes, or #{pixel_count} pixels")

  # Get the actual data as an array
  bitmap.pos = data_offset
  result = bitmap.read(byte_count)
end

File.open(ARGV[1], 'wb') do |out|
  out.write(result)
end

