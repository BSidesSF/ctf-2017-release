##
# PoracleDecryptor.rb
# Created: December 8, 2012
# By: Ron Bowes
#
# TODO
##
#

class PoracleDecryptor
  private
  def _generate_set(base_list)
    mapping = []
    base_list.each do |i|
      mapping[i.ord()] = true
    end

    0.upto(255) do |i|
      if(!mapping[i])
        base_list << i.chr
      end
    end

    return base_list
  end

  private
  def _find_character_decrypt(character, block, previous, plaintext, character_set)
    # First, generate a good C' (C prime) value, which is what we're going to
    # set the previous block to. It's the plaintext we have so far, XORed with
    # the expected padding, XORed with the previous block. This is like the
    # ketchup in the secret sauce.
    blockprime = "\0" * @blocksize
    (@blocksize - 1).step(character + 1, -1) do |i|
      blockprime[i] = (plaintext[i].ord() ^ (@blocksize - character) ^ previous[i].ord()).chr
    end

    # Try all possible characters in the set (hopefully the set is exhaustive)
    character_set.each do |current_guess|
      # Calculate the next character of C' based on tghe plaintext character we
      # want to guess. This is the mayo in the secret sauce.
      blockprime[character] = ((@blocksize - character) ^ previous[character].ord() ^ current_guess.ord()).chr

      # Ask the mod to attempt to decrypt the string. This is the last
      # ingredient in the secret sauce - the relish, as it were.
      result = @do_decrypt.call(blockprime + block)

      # If it successfully decrypted, we found the character!
      if(result)
        # Validate the result if we're working on the last character
        false_positive = false
        if(character == @blocksize - 1)
          # Modify the second-last character in any way (we XOR with 1 for
          # simplicity)
          blockprime[character - 1] = (blockprime[character - 1].ord() ^ 1).chr
          # If the decryption fails, we hit a false positive!
          if(!@do_decrypt.call(blockprime + block))
            if(@verbose)
              puts("Hit a false positive!")
            end
            false_positive = true
          end
        end

        # If it's not a false positive, return the character we just found
        if(!false_positive)
          return current_guess
        end
      end
    end

    raise("Couldn't find a valid encoding!")
  end

  private
  def _do_block_decrypt(block, previous, has_padding = false, character_set = nil)
    # It doesn't matter what we default the plaintext to, as long as it's long
    # enough
    plaintext = "\0" * @blocksize

    # Loop through the string from the end to the beginning
    (block.length - 1).step(0, -1) do |character|
      # When character is below 0, we've arrived at the beginning of the string
      if(character >= block.length)
        raise("Could not decode!")
      end

      # Try to be intelligent about which character we guess first, to save
      # requests
      set = nil
      if(character == block.length - 1 && has_padding)
        # For the last character of a block with padding, guess the padding
        set = _generate_set([1.chr])
      elsif(has_padding && character >= block.length - plaintext[block.length - 1].ord())
        # If we're still in the padding, guess the proper padding value (it's
        # known)
        set = _generate_set([plaintext[block.length - 1]])
      elsif(character_set)
        # If the module provides a character_set, use that
        set = _generate_set(character_set)
      else
        # Otherwise, use a common English ordering that I generated based on
        # the Battlestar Galactica wikia page (yes, I'm serious :) )
        set = _generate_set(' eationsrlhdcumpfgybw.k:v-/,CT0SA;B#G2xI1PFWE)3(*M\'!LRDHN_"9UO54Vj87q$K6zJY%?Z+=@QX&|[]<>^{}'.chars.to_a)
      end

      # Break the current character (this is the secret sauce)
      c = _find_character_decrypt(character, block, previous, plaintext, set)
      plaintext[character] = c

      if(@verbose)
        puts(plaintext)
      end
    end

    return plaintext
  end

  public
  def decrypt(data, iv = nil, character_set = nil)
    # Default to a nil IV
    if(iv.nil?)
      iv = "\x00" * @blocksize
    end

    # Add the IV to the start of the encrypted string (for simplicity)
    data  = iv + data
    blockcount = data.length / @blocksize

    # Validate the blocksize
    if(data.length % @blocksize != 0)
      puts("Encrypted data isn't a multiple of the blocksize! Is this a block cipher?")
    end

    # Tell the user what's going on
    if(@verbose)
      puts("> Starting Poracle decrypter")
      puts(">> Encrypted length: %d" % data.length)
      puts(">> Blocksize: %d" % @blocksize)
      puts(">> %d blocks:" % blockcount)
    end

    # Split the data into blocks
    blocks = data.unpack("a#{@blocksize}" * blockcount)
    i = 0
    blocks.each do |b|
      i = i + 1
      if(@verbose)
        puts(">>> Block #{i}: #{b.unpack("H*")}")
      end
    end

    # Decrypt all the blocks - from the last to the first (after the IV).
    # This can actually be done in any order.
    result = ''
    is_last_block = true
    (blocks.size - 1).step(1, -1) do |j|
      # Process this block - this is where the magic happens
      new_result = _do_block_decrypt(blocks[j], blocks[j - 1], is_last_block, character_set)
      if(new_result.nil?)
        return nil
      end
      is_last_block = false
      result = new_result + result
      if(@verbose)
        puts(" --> #{result}")
      end
    end

    # Validate and remove the padding
    pad_bytes = result[result.length - 1].chr
    if(result[result.length - pad_bytes.ord(), result.length - 1] != pad_bytes * pad_bytes.ord())
      puts("Bad padding:")
      puts(result.unpack("H*"))
      return nil
    end

    # Remove the padding
    result = result[0, result.length - pad_bytes.ord()]

    return result
  end

  private
  def _find_character_encrypt(index, result, next_block)
    # Make sure sanity is happening
    if(next_block.length() != @blocksize)
      raise("Block is the wrong size!")
    end

    # Save us from having to calculate
    padding_chr = (@blocksize - index).chr()

    # Create as much of a block as we can, with the proper padding
    block = "\0" * @blocksize
    index.upto(@blocksize - 1) do |i|
      block[i] = (padding_chr.ord() ^ result[i].ord()).chr()
    end

    0.upto(255) do |c|
      block[index] = (padding_chr.ord() ^ next_block[index].ord() ^ c).chr

      # Attempt to decrypt the string. This is the last ingredient in the
      # secret sauce - the relish, as it were.
      if(@do_decrypt.call(block + next_block))
        return (block[index].ord() ^ padding_chr.ord()).chr()
      end
    end

    raise("Couldn't find a valid encoding!")
  end

  private
  def _get_block_encrypt(block, next_block)
    # It doesn't matter what we default the result to, as long as it's long
    # enough
    result = "\0" * @blocksize

    # Loop through the string from the end to the beginning
    (@blocksize - 1).step(0, -1) do |index|
      result[index] = _find_character_encrypt(index, result, next_block)

      if(@verbose)
        puts('Current string => %s' % (result+next_block).unpack('H*'))
      end
    end

    0.upto(@blocksize - 1) do |i|
      result[i] = (result[i].ord() ^ block[i].ord()).chr()
    end

    return result
  end

  public
  def encrypt(data)
    # Add the IV to the start of the encrypted string (for simplicity)
    blockcount = (data.length / @blocksize) + 1

    # Add the padding
    padding_bytes = @blocksize - (data.length % @blocksize)
    data = data + (padding_bytes.chr() * padding_bytes)

    # Tell the user what's going on
    if(@verbose)
      puts("> Starting Poracle encryptor")
      puts(">> Encrypted length: %d" % data.length)
      puts(">> Blocksize: %d" % @blocksize)
      puts(">> %d blocks:" % blockcount)
    end

    # Split the data into blocks
    data_blocks = data.unpack("a#{@blocksize}" * blockcount)

    # The 'final' block can be defaulted to anything
    last_block = (0...@blocksize).map { rand(255).chr }.join
    result = last_block
    data_blocks.reverse().each do |b|
      last_block = _get_block_encrypt(b, last_block)
      result = last_block + result
      if(@verbose)
        puts(">>> #{result.unpack("H*")}")
      end
    end

    return result
  end

  def initialize(blocksize, verbose = false)
    @blocksize = blocksize
    @verbose = verbose
    @do_decrypt = proc 
  end
end
