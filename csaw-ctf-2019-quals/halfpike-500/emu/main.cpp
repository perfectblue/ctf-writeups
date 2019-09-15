#include <array>
#include <cstdint>
#include <functional>
#include <iostream>
#include <optional>
#include <cstdio>
#include <type_traits>
#include <unordered_map>

namespace bits {
// can be used for 4 or 12 bit integers
template <typename T> class machine_int {
  static_assert(std::is_same_v<T, uint8_t> || std::is_same_v<T, int8_t> ||
                std::is_same_v<T, uint16_t>);

public:
  static constexpr auto bit_mask = std::make_unsigned_t<T>(-1) << 4;

  machine_int() : value(0){};
  inline machine_int(const T val) : value(val << 4) { /* TODO check valid val */
  }
  inline machine_int<T> &operator=(const T val) { /*TODO check valid val */
    value = val << 4;
    return *this;
  }

  inline machine_int(const machine_int<T> &val) : value(val.value) {}
  inline machine_int<T> &operator=(const machine_int<T> val) {
    value = val.value;
    return *this;
  }

  // operators:
  template <typename U>
  inline machine_int<T> operator+(const machine_int<U> rhs) const {
    return ((value + rhs.value) & bit_mask) >> 4;
  }
  inline machine_int<T> operator+(const T rhs) const {
    return *this + machine_int<T>{rhs};
  }

  template <typename U>
  inline machine_int<T> &operator+=(const machine_int<U> rhs) {
    value = (*this + rhs).value;
    return *this;
  }
  inline machine_int<T> &operator+=(const T rhs) {
    return *this += machine_int<T>{rhs};
  }

  template <typename U>
  inline machine_int<T> operator-(const machine_int<U> rhs) const {
    return ((value - rhs.value) & bit_mask) >> 4;
  }
  inline machine_int<T> operator-(const T rhs) const {
    return *this - machine_int<T>{rhs};
  }

  template <typename U>
  inline machine_int<T> &operator-=(const machine_int<U> rhs) {
    value = (*this - rhs).value;
    return *this;
  }
  inline machine_int<T> &operator-=(const T rhs) {
    return *this -= machine_int<T>{rhs};
  }

  inline machine_int<T> operator<<(const size_t shift) const {
    return get() << shift;
  }
  inline machine_int<T> operator>>(const size_t shift) const {
    return get() >> shift;
  }
  inline machine_int<T> operator|(const machine_int<T> rhs) const {
    return get() | rhs.get();
  }
  inline machine_int<T> operator&(const machine_int<T> rhs) const {
    return get() & rhs.get();
  }

  inline bool operator==(const machine_int<T> rhs) const {
    return get() == rhs.get();
  }

  inline machine_int<T> &operator++() {
    *this += 1;
    return *this;
  }
  inline machine_int<T> operator++(int) {
    const auto ret = *this;
    *this += 1;
    return ret;
  }

  inline machine_int<T> &operator--() {
    *this -= 1;
    return *this;
  }
  inline machine_int<T> operator--(int) {
    const auto ret = *this;
    *this -= 1;
    return ret;
  }

  // access value
  inline T get() const { return value >> 4; }

private:
  T value; // we use the TOP 4 bits of value, and then mask off the bottom 4
};
} // namespace bits

using uint4_t = bits::machine_int<uint8_t>;
using int4_t = bits::machine_int<int8_t>;
using uint12_t = bits::machine_int<uint16_t>;

std::ostream &operator<<(std::ostream &os, uint4_t val) {
  return os << (unsigned int)val.get();
}
std::ostream &operator<<(std::ostream &os, int4_t val) {
  return os << (int)val.get();
}
std::ostream &operator<<(std::ostream &os, uint12_t val) {
  return os << (unsigned int)val.get();
}

struct Machine_State {
  uint12_t pc{0};
  std::array<uint12_t, 3> callstack{0, 0, 0};
  size_t curr_callstack_offset{0};
  std::array<uint4_t, 16> registers{0, 0, 0, 0, 0, 0, 0, 0,
                                    0, 0, 0, 0, 0, 0, 0, 0};
  uint4_t acc{0};
  uint4_t carry_bit{0};
  uint8_t src_reg{0}; // the register set by the SRC instruction

  std::array<uint8_t, 4096> rom{};
  std::array<std::array<uint4_t, 256>, 8> ram_banks{};
  size_t selected_ram_bank{0};

  // buffers while writing and reading with wrr and rdr instructions
  std::optional<uint4_t> write_hold{std::nullopt};
  std::optional<uint4_t> read_hold{std::nullopt};
};

enum class Opcode {
  NOP,
  JCN,
  FIM,
  SRC,
  FIN,
  JIN,
  JUN,
  JMS,
  INC,
  ISZ,
  ADD,
  SUB,
  LD,
  XCH,
  BBL,
  LDM,
  WRM,
  WMP,
  WRR,
  WPM,
  WR0,
  WR1,
  WR2,
  WR3,
  SBM,
  RDM,
  RDR,
  ADM,
  RD0,
  RD1,
  RD2,
  RD3,
  CLB,
  CLC,
  IAC,
  CMC,
  CMA,
  RAL,
  RAR,
  TCC,
  DAC,
  TCS,
  STC,
  DAA,
  KBP,
  DCL,
};

Opcode get_current_opcode(Machine_State &state) {
  auto opbyte1 = state.rom.at(state.pc.get());
  switch (opbyte1 >> 4) {
  case 0b0000:
    return Opcode::NOP;
  case 0b0001:
    return Opcode::JCN;
  case 0b0010:
    switch (opbyte1 & 1) {
    case 0b0:
      return Opcode::FIM;
    case 0b1:
      return Opcode::SRC;
    }
  case 0b0011:
    switch (opbyte1 & 1) {
    case 0b0:
      return Opcode::FIN;
    case 0b1:
      return Opcode::JIN;
    }
  case 0b0100:
    return Opcode::JUN;
  case 0b0101:
    return Opcode::JMS;
  case 0b0110:
    return Opcode::INC;
  case 0b0111:
    return Opcode::ISZ;
  case 0b1000:
    return Opcode::ADD;
  case 0b1001:
    return Opcode::SUB;
  case 0b1010:
    return Opcode::LD;
  case 0b1011:
    return Opcode::XCH;
  case 0b1100:
    return Opcode::BBL;
  case 0b1101:
    return Opcode::LDM;
  case 0b1110:
    switch (opbyte1 & 0xf) {
    case 0b0000:
      return Opcode::WRM;
    case 0b0001:
      return Opcode::WMP;
    case 0b0010:
      return Opcode::WRR;
    case 0b0011:
      return Opcode::WR0;
    case 0b0100:
      return Opcode::WR1;
    case 0b0101:
      return Opcode::WR2;
    case 0b0110:
      return Opcode::WR3;
    case 0b0111:
      return Opcode::SBM;
    case 0b1001:
      return Opcode::RDM;
    case 0b1010:
      return Opcode::RDR;
    case 0b1011:
      return Opcode::ADM;
    case 0b1100:
      return Opcode::RD0;
    case 0b1101:
      return Opcode::RD1;
    case 0b1110:
      return Opcode::RD2;
    case 0b1111:
      return Opcode::RD3;
    }
  case 0b1111:
    switch (opbyte1 & 0xf) {
    case 0b0000:
      return Opcode::CLB;
    case 0b0001:
      return Opcode::CLC;
    case 0b0010:
      return Opcode::IAC;
    case 0b0011:
      return Opcode::CMC;
    case 0b0100:
      return Opcode::CMA;
    case 0b0101:
      return Opcode::RAL;
    case 0b0110:
      return Opcode::RAR;
    case 0b0111:
      return Opcode::TCC;
    case 0b1000:
      return Opcode::DAC;
    case 0b1001:
      return Opcode::TCS;
    case 0b1010:
      return Opcode::STC;
    case 0b1011:
      return Opcode::DAA;
    case 0b1100:
      return Opcode::KBP;
    case 0b1101:
      return Opcode::DCL;
    }
  }

  std::cerr << "Failed to decode opcode!!" << std::endl;
  abort();
}

size_t get_opcode_size(const Opcode opcode) {
  const std::unordered_map<Opcode, size_t> opcodes{
      {Opcode::NOP, 1}, {Opcode::JCN, 2}, {Opcode::FIM, 2}, {Opcode::SRC, 1},
      {Opcode::FIN, 1}, {Opcode::JIN, 1}, {Opcode::JUN, 2}, {Opcode::JMS, 2},
      {Opcode::INC, 1}, {Opcode::ISZ, 2}, {Opcode::ADD, 1}, {Opcode::SUB, 1},
      {Opcode::LD, 1},  {Opcode::XCH, 1}, {Opcode::BBL, 1}, {Opcode::LDM, 1},
      {Opcode::WRM, 1}, {Opcode::WMP, 1}, {Opcode::WRR, 1}, {Opcode::WPM, 1},
      {Opcode::WR0, 1}, {Opcode::WR1, 1}, {Opcode::WR2, 1}, {Opcode::WR3, 1},
      {Opcode::SBM, 1}, {Opcode::RDM, 1}, {Opcode::RDR, 1}, {Opcode::ADM, 1},
      {Opcode::RD0, 1}, {Opcode::RD1, 1}, {Opcode::RD2, 1}, {Opcode::RD3, 1},
      {Opcode::CLB, 1}, {Opcode::CLC, 1}, {Opcode::IAC, 1}, {Opcode::CMC, 1},
      {Opcode::CMA, 1}, {Opcode::RAL, 1}, {Opcode::RAR, 1}, {Opcode::TCC, 1},
      {Opcode::DAC, 1}, {Opcode::TCS, 1}, {Opcode::STC, 1}, {Opcode::DAA, 1},
      {Opcode::KBP, 1}, {Opcode::DCL, 1}};
  return opcodes.at(opcode);
}

std::string get_opcode_name(const Opcode opcode) {
  const std::unordered_map<Opcode, std::string> opcodes{
      {Opcode::NOP, "NOP"}, {Opcode::JCN, "JCN"}, {Opcode::FIM, "FIM"},
      {Opcode::SRC, "SRC"}, {Opcode::FIN, "FIN"}, {Opcode::JIN, "JIN"},
      {Opcode::JUN, "JUN"}, {Opcode::JMS, "JMS"}, {Opcode::INC, "INC"},
      {Opcode::ISZ, "ISZ"}, {Opcode::ADD, "ADD"}, {Opcode::SUB, "SUB"},
      {Opcode::LD, "LD"},   {Opcode::XCH, "XCH"}, {Opcode::BBL, "BBL"},
      {Opcode::LDM, "LDM"}, {Opcode::WRM, "WRM"}, {Opcode::WMP, "WMP"},
      {Opcode::WRR, "WRR"}, {Opcode::WPM, "WPM"}, {Opcode::WR0, "WR0"},
      {Opcode::WR1, "WR1"}, {Opcode::WR2, "WR2"}, {Opcode::WR3, "WR3"},
      {Opcode::SBM, "SBM"}, {Opcode::RDM, "RDM"}, {Opcode::RDR, "RDR"},
      {Opcode::ADM, "ADM"}, {Opcode::RD0, "RD0"}, {Opcode::RD1, "RD1"},
      {Opcode::RD2, "RD2"}, {Opcode::RD3, "RD3"}, {Opcode::CLB, "CLB"},
      {Opcode::CLC, "CLC"}, {Opcode::IAC, "IAC"}, {Opcode::CMC, "CMC"},
      {Opcode::CMA, "CMA"}, {Opcode::RAL, "RAL"}, {Opcode::RAR, "RAR"},
      {Opcode::TCC, "TCC"}, {Opcode::DAC, "DAC"}, {Opcode::TCS, "TCS"},
      {Opcode::STC, "STC"}, {Opcode::DAA, "DAA"}, {Opcode::KBP, "KBP"},
      {Opcode::DCL, "DCL"},
  };
  return opcodes.at(opcode);
}

/*
void dump_machine_state(Machine_State &state) {
  // std::cout << std::hex << std::showbase;

  std::cout << "pc: " << std::hex << std::showbase << state.pc << ", ";
  for (size_t i = 0; i < state.registers.size(); i++) {
    std::cout << 'r' << std::dec << i << ": " << std::hex << std::showbase
              << state.registers.at(i) << ", ";
  }
  std::cout << "src: " << std::hex << std::showbase << int(state.src_reg)
            << ", ";

  std::cout << "bank: " << std::hex << std::showbase
            << int(state.selected_ram_bank) << ", ";

  std::cout << "carry: " << std::hex << std::showbase << state.carry_bit
            << ", ";
  std::cout << "acc: " << std::hex << std::showbase << state.acc << ", ";
  std::cout << std::endl;
  for (size_t i = 0; i < 8; i++) {
    // std::cout << "stop[" << i << "]: " << state.ram_banks.at(i).at(158) << ",
    // ";
    std::cout << "state " << std::dec << i << ": "
              << "stop: " << std::hex << state.ram_banks.at(i).at(158)
              << ", fail: " << std::hex << state.ram_banks.at(i).at(157) << ", "
              << "pc: " << std::hex << state.ram_banks.at(i).at(159) << ", ";
    for (size_t j = 0; j < 16; j++) {
      std::cout << "r" << std::dec << j << ": " << std::hex
                << state.ram_banks.at(i).at(160 + j) << ", ";
    }
    std::cout << std::endl;
  }
}
*/

void set_register_pair(Machine_State &state, uint8_t pair_idx, uint8_t value) {
  state.registers[pair_idx * 2] = value >> 4;
  state.registers[pair_idx * 2 + 1] = value & 0xf;
}

void tick(Machine_State &state) {
  const auto decode_pc = state.pc;
  const std::unordered_map<Opcode, std::function<void(Machine_State &)>>
      opcode_handlers{
          {Opcode::NOP, [decode_pc](Machine_State &state) { ; }},
          {Opcode::JCN,
           [decode_pc](Machine_State &state) {
             const auto cond_code = state.rom.at(decode_pc.get()) & 0xf;
             const auto target =
                 (state.pc.get() & 0xf00) | state.rom.at((decode_pc + 1).get());
             bool should_jump = false;
             // jump if test signal = 0
             if (cond_code & 0b0001) {
               should_jump = should_jump || false; // XXX: unimplemented
             }
             // jump if carry bit = 1
             if (cond_code & 0b0010) {
               should_jump = should_jump || (state.carry_bit == 1);
             }
             // jump if acc = 0
             if (cond_code & 0b0100) {
               should_jump = should_jump || (state.acc == 0);
             }
             // invert condition
             if (cond_code & 0b1000) {
               should_jump = !should_jump;
             }

             if (should_jump) {
               state.pc = target;
             }
           }},
          {Opcode::FIM,
           [decode_pc](Machine_State &state) {
             const auto register_pair_idx =
                 (state.rom.at(decode_pc.get()) & 0b00001110) >> 1;
             const auto data = state.rom.at((decode_pc + 1).get());
             set_register_pair(state, register_pair_idx, data);
           }},
          {Opcode::SRC,
           [decode_pc](Machine_State &state) {
             const auto register_pair_idx =
                 (state.rom.at(decode_pc.get()) & 0b00001110) >> 1;
             state.src_reg =
                 (state.registers[2 * register_pair_idx].get() << 4) |
                 (state.registers[2 * register_pair_idx + 1].get());
           }},
          {Opcode::FIN,
           [decode_pc](Machine_State &state) {
             const auto register_pair_idx =
                 (state.rom.at(decode_pc.get()) & 0b00001110) >> 1;
             const uint12_t pc_high = (state.pc & 0xf00) >> 8;
             const uint12_t high_reg = uint12_t{state.registers[0].get()};
             const uint12_t low_reg = uint12_t{state.registers[1].get()};
             const uint12_t target =
                 (pc_high << 8) | (high_reg << 4) | (low_reg);
             const auto value = state.rom.at(target.get());
             set_register_pair(state, register_pair_idx, value);
           }},
          {Opcode::JIN,
           [decode_pc](Machine_State &state) {
             const auto register_pair_idx =
                 (state.rom.at(decode_pc.get()) & 0b00001110) >> 1;
             const uint8_t low_portion =
                 (state.registers[2 * register_pair_idx].get() << 4) |
                 (state.registers[2 * register_pair_idx + 1].get());
             state.pc = (state.pc & 0xf00) | low_portion;
           }},
          {Opcode::JUN,
           [decode_pc](Machine_State &state) {
             // Jump unconditional
             const auto target =
                 uint12_t{(uint16_t(state.rom.at(decode_pc.get())) & 0xf) << 8 |
                          uint16_t(state.rom.at((decode_pc + 1).get()))};
             state.pc = target;
           }},
          {Opcode::JMS,
           [decode_pc](Machine_State &state) {
             const auto target =
                 uint12_t{(uint16_t(state.rom.at(decode_pc.get())) & 0xf) << 8 |
                          uint16_t(state.rom.at((decode_pc + 1).get()))};
             state.curr_callstack_offset =
                 (state.curr_callstack_offset + 1) % 3;
             state.callstack[state.curr_callstack_offset] = state.pc;
             state.pc = target;
           }},
          {Opcode::INC,
           [decode_pc](Machine_State &state) {
             const auto reg_number = state.rom.at(decode_pc.get()) & 0xf;
             state.registers[reg_number]++;
           }},
          {Opcode::ISZ,
           [decode_pc](Machine_State &state) {
             const auto register_idx = state.rom.at(decode_pc.get()) & 0b1111;
             const auto target =
                 (state.pc & 0xf00) | state.rom.at((decode_pc + 1).get());
             state.registers[register_idx]++;
             if (state.registers[register_idx] == 0) {
               state.pc = target;
             }
           }},
          {Opcode::ADD,
           [decode_pc](Machine_State &state) {
             const auto reg_num = state.rom.at(decode_pc.get()) & 0xf;
             const auto reg = state.registers[reg_num];
             const auto will_carry = (reg.get() + state.acc.get()) > 0xf;
             state.acc += reg;
             state.carry_bit = will_carry;
           }},
          {Opcode::SUB,
           [decode_pc](Machine_State &state) {
             const auto reg_num = state.rom.at(decode_pc.get()) & 0xf;
             // we do the subtract in full-width by adding complements of the
             // reg and state, then grab the bits we want from the result
             const auto result_full = state.acc.get() +
                                      ~state.registers[reg_num].get() +
                                      (~state.carry_bit.get() & 0b1);
             state.carry_bit = (result_full & 0x10) >> 4;
             state.acc = result_full & 0xf;
           }},
          {Opcode::LD,
           [decode_pc](Machine_State &state) {
             const auto reg_num = state.rom.at(decode_pc.get()) & 0xf;
             state.acc = state.registers[reg_num];
           }},
          {Opcode::XCH,
           [decode_pc](Machine_State &state) {
             const auto reg_number = state.rom.at(decode_pc.get()) & 0xf;
             std::swap(state.registers[reg_number], state.acc);
           }},
          {Opcode::BBL,
           [decode_pc](Machine_State &state) {
             state.acc = state.rom.at(decode_pc.get()) & 0xf;
             state.pc = state.callstack.at(state.curr_callstack_offset);
             // adjust callstack offset, wrapping around appropriately.
             if (state.curr_callstack_offset == 0) {
               state.curr_callstack_offset = 2;
             } else {
               state.curr_callstack_offset--;
             }
           }},
          {Opcode::LDM,
           [decode_pc](Machine_State &state) {
             state.acc = uint4_t{state.rom.at(decode_pc.get()) & 0xf};
           }},
          {Opcode::WRM,
           [decode_pc](Machine_State &state) {
             state.ram_banks[state.selected_ram_bank][state.src_reg] =
                 state.acc;
             fprintf(stderr, "Write bank %d src %x <- %x\n", state.selected_ram_bank, state.src_reg, state.acc.get());
           }},
          {Opcode::WMP,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: FIN" << std::endl;
             abort();
           }},
          {Opcode::WRR,
           [decode_pc](Machine_State &state) {
             // this is technically not *quite* what this instruction is
             // supposed to do, but y'know, gotta get io and this does io.
             if (state.write_hold.has_value()) {
               char c = (state.write_hold->get() << 4) | state.acc.get();
               putchar(c);
               state.write_hold = std::nullopt;
             } else {
               state.write_hold = state.acc;
             }
           }},
          {Opcode::WPM,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: WPM" << std::endl;
             abort();
           }},
          {Opcode::WR0,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: WR0" << std::endl;
             abort();
           }},
          {Opcode::WR1,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: WR1" << std::endl;
             abort();
           }},
          {Opcode::WR2,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: WR2" << std::endl;
             abort();
           }},
          {Opcode::WR3,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: WR3" << std::endl;
             abort();
           }},
          {Opcode::SBM,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: SBM" << std::endl;
             abort();
           }},
          {Opcode::RDM,
           [decode_pc](Machine_State &state) {
             state.acc =
                 state.ram_banks[state.selected_ram_bank][state.src_reg];
             fprintf(stderr, "Read bank %d src %x -> %x\n", state.selected_ram_bank, state.src_reg, state.acc.get());
           }},
          {Opcode::RDR,
           [decode_pc](Machine_State &state) {
             // much like WRR, this isn't quite the intended behavior of this
             // instruction. We're basically using it as a "read a character
             // from stdin, one nibble at a time" function
             if (state.read_hold.has_value()) {
               state.acc = *(state.read_hold);
               state.read_hold = std::nullopt;
             } else {
               uint8_t c = uint8_t(getchar());
               state.acc = c >> 4;
               state.read_hold = c & 0xf;
             }
             fprintf(stderr, "Read stdin -> %x\n", state.acc.get());
           }},
          {Opcode::ADM,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: ADM" << std::endl;
             abort();
           }},
          {Opcode::RD0,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: RD0" << std::endl;
             abort();
           }},
          {Opcode::RD1,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: RD1" << std::endl;
             abort();
           }},
          {Opcode::RD2,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: RD2" << std::endl;
             abort();
           }},
          {Opcode::RD3,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: RD3" << std::endl;
             abort();
           }},
          {Opcode::CLB,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: CLB" << std::endl;
             abort();
           }},
          {Opcode::CLC,
           [decode_pc](Machine_State &state) { state.carry_bit = 0; }},
          {Opcode::IAC,
           [decode_pc](Machine_State &state) {
             state.acc++;
             if (state.acc == 0) {
               state.carry_bit = 1;
             } else {
               state.carry_bit = 0;
             }
           }},
          {Opcode::CMC,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: CMC" << std::endl;
             abort();
           }},
          {Opcode::CMA,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: CMA" << std::endl;
             abort();
           }},
          {Opcode::RAL,
           [decode_pc](Machine_State &state) {
             const auto old_acc = state.acc;
             const auto old_carry = state.carry_bit;
             state.acc = (old_acc << 1) | old_carry;
             state.carry_bit = old_acc >> 3;
           }},
          {Opcode::RAR,
           [decode_pc](Machine_State &state) {
             const auto old_acc = state.acc;
             const auto old_carry = state.carry_bit;
             state.acc = (old_acc >> 1) | (old_carry << 3);
             state.carry_bit = old_acc & 0b1;
           }},
          {Opcode::TCC,
           [decode_pc](Machine_State &state) {
             state.acc = state.carry_bit;
             state.carry_bit = 0;
           }},
          {Opcode::DAC,
           [decode_pc](Machine_State &state) {
             const auto old_value = state.acc;
             state.acc--;
             if ((old_value & 0b1000).get() != 0 &&
                 (state.acc & 0b1000).get() == 0) {
               state.carry_bit = 0;
             } else {
               state.carry_bit = 1;
             }
           }},
          {Opcode::TCS,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: TCS" << std::endl;
             abort();
           }},
          {Opcode::STC,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: STC" << std::endl;
             abort();
           }},
          {Opcode::DAA,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: DAA" << std::endl;
             abort();
           }},
          {Opcode::KBP,
           [decode_pc](Machine_State &state) {
             std::cout << "unimpl: KBP" << std::endl;
             abort();
           }},
          {Opcode::DCL,
           [decode_pc](Machine_State &state) {
             const auto bank_num = state.acc & 0b0111;
             state.selected_ram_bank = size_t(bank_num.get());
             fprintf(stderr, "Select bank %d\n", bank_num.get());
           }},
      };
  auto opcode = get_current_opcode(state);
  fprintf(stderr, "0x%03x: %s\n", state.pc.get(), get_opcode_name(opcode).c_str());
  state.pc += get_opcode_size(opcode);
  opcode_handlers.at(opcode)(state);
}

int main(int argc, char **argv) {
  // unbuffer
  setbuf(stdin, NULL);
  setbuf(stdout, NULL);

  if (argc < 2) {
    std::cout << "Usage: " << argv[0] << " <rom file>" << std::endl;
    return 1;
  }

  Machine_State state;
  // load rom:
  FILE *fd = fopen(argv[1], "r");
  if (!fd) {
    perror("Open:");
    return 1;
  }
  if (fread(state.rom.data(), 1, state.rom.size(), fd) != state.rom.size()) {
    perror("Read:");
    return 1;
  }

  // emulate
  while (true) {
    tick(state);
  }
}
