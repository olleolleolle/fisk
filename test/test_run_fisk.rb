require "helper"
require "fisk/helpers"

class RunFiskTest < Fisk::Test
  def test_run_fisk
    fisk = Fisk.new
    mem = Fisk::Helpers.mmap_jit 4096

    binary = fisk.asm do
      push rbp
      mov rbp, rsp
      mov rax, imm32(100)
      pop rbp
      ret
    end

    Fisk::Helpers.memcpy mem, binary.string, binary.string.bytesize
    func = Fiddle::Function.new mem.to_i, [], Fiddle::TYPE_INT
    assert_equal 100, func.call
  end

  def test_jit_memory_has_size
    mem = Fisk::Helpers.mmap_jit 100
    assert_equal 100, mem.size
  end

  def test_fisk_jit
    fisk = Fisk.new
    jitbuf = Fisk::Helpers.jitbuffer 4096

    fisk.asm jitbuf do
      push rbp
      mov rbp, rsp
      mov rax, imm32(100)
      pop rbp
      ret
    end

    func = jitbuf.to_function [], Fiddle::TYPE_INT
    assert_equal 100, func.call
  end
end
