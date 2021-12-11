void write64(void *addr, uint64_t value) {
  *(uint64_t*)addr = value;
}

void write32(void *addr, uint32_t value) {
  *(uint32_t*)addr = value;
}

void write16(void *addr, uint16_t value) {
  *(uint16_t*)addr = value;
}

void write8(void *addr, uint8_t value) {
  *(uint8_t*)addr = value;
}

uint64_t read64(void *addr) {
  return *(uint64_t*)addr;
}

uint32_t read32(void *addr) {
  return *(uint32_t*)addr;
}

uint16_t read16(void *addr) {
  return *(uint16_t*)addr;
}

uint8_t read8(void *addr) {
  return *(uint8_t*)addr;
}