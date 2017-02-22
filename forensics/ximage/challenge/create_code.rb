f = File.open('code.asm', 'w')

f.write <<EOC
bits 32

; f
xor ebx, ebx
mov ebx, 1

; Buffer
call $+5
pop ecx
mov byte [ecx], 0x00

; length
xor edx, edx
mov edx, 1

EOC

str = "***\n%s\n***\n" % ARGV[0]
if(str.nil?)
  puts("Usage: ruby ./create_code.rb <str>")
  exit(1)
end

current = 0
str.bytes.each do |c|
  offset = 0
  if(current < c)
    offset = (c - current)
    f.puts("add byte [ecx], 0x%02x ; '%s'" % [offset, c < 0x20 ? ('0x%02x' % c) : c.chr])
  elsif(current > c)
    offset = (current - c)
    f.puts("sub byte [ecx], 0x%02x ; '%s'" % [offset, c < 0x20 ? ('0x%02x' % c) : c.chr])
  end

  current = c

  f.puts("xor eax, eax")
  f.puts("mov al, 4")
  f.puts("int 0x80")
  f.puts()
end
f.write <<EOC
xor eax, eax
inc al
xor ebx, ebx
int 0x80
EOC
f.close()
