## Hardware information
ARCH = armv7-a
MCPU = cortex-a8
BOARD = realview-pb-a8

## Compiler & flag information
ARMCOMPILER = /usr/bin/arm-none-eabi-
CC = $(ARMCOMPILER)gcc
AS = $(ARMCOMPILER)as
LD = $(ARMCOMPILER)ld
OC = $(ARMCOMPILER)objcopy
DUMP = $(ARMCOMPILER)objdump
LK_SCRIPT = eos.ld

CFLAGS = -march=$(ARCH) -mcpu=$(MCPU) -g -c
ASFLAGS = -march=$(ARCH) -mcpu=$(MCPU) -g

LDFLAGS = -n -T $(LK_SCRIPT)
OCFLAGS = -O binary
DUMPFLAGS = -D

## Directory information
TOP_DIR = ..
BUILD_DIR = $(TOP_DIR)/build
INC_DIR = $(TOP_DIR)/include
BOOT_DIR = $(TOP_DIR)/boot
BOOT_OUT_DIR = $(BOOT_DIR)/output

BOOT_INC = -I$(INC_DIR)
## Sources and Objects information
BOOT_ASRCS = $(wildcard $(BOOT_DIR)/*.S)
BOOT_AOBJS = $(patsubst $(BOOT_DIR)/%.S, $(BOOT_OUT_DIR)/%.o, $(BOOT_ASRCS))

BOOT_CSRCS = $(wildcard $(BOOT_DIR)/*.c)
BOOT_COBJS = $(patsubst $(BOOT_DIR)/%.c, $(BOOT_OUT_DIR)/%.o, $(BOOT_CSRCS))

OBJS = $(BOOT_AOBJS) $(BOOT_COBJS)

## Target output information
TARGET = eos.axf
TARGET_BIN = eos.bin
TARGET_DUMP = eos.dump
TARGET_MAP = eos.map

## Command
.PHONY: all clean dump qemu gdb

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -Map=$(TARGET_MAP) -o $@ $^
	$(OC) $(OCFLAGS) $@ $(TARGET_BIN)
	$(DUMP) $(DUMPFLAGS) $@ > $(TARGET).dump

$(BOOT_AOBJS): $(BOOT_ASRCS)
	@echo "**************BOOT_ASM_COMPILE**************"
	mkdir -p $(BOOT_OUT_DIR)
	$(CC) $(CFLAGS) $(BOOT_INC) -o $@ $<

$(BOOT_COBJS): $(BOOT_CSRCS)
	@echo "**************BOOT_C_COMPILE**************"
	mkdir -p $(BOOT_OUT_DIR)
	$(CC) $(CFLAGS) $(BOOT_INC) -o $@ $<

qemu:
	qemu-system-arm -M $(BOARD) -kernel $(TARGET) -S -nographic -gdb tcp::1234,ipv4

gdb:
	gdb-multiarch $(TARGET)

clean:
	rm -rf $(BOOT_OUT_DIR) $(TARGET_DUMP) $(TARGET) $(TARGET_BIN)