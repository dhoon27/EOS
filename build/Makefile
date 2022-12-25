TARGET = rvpb

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
LK_SCRIPT = $(TARGET)_lk.ld

CFLAGS = -march=$(ARCH) -mcpu=$(MCPU) -g -c -std=c11
ASFLAGS = -march=$(ARCH) -mcpu=$(MCPU) -g -std=c11

LDFLAGS = -nostartfiles -nostdlib -nodefaultlibs -static -lgcc

OCFLAGS = -O binary
DUMPFLAGS = -D

## Directory information
TOP_DIR = ..
BUILD_DIR = $(TOP_DIR)/build
OUTPUT_DIR = $(BUILD_DIR)/output

INC_DIR = $(TOP_DIR)/include

BOOT_DIR = $(TOP_DIR)/boot

HAL_DIR = $(TOP_DIR)/hal
HAL_TARGET_DIR = $(TOP_DIR)/hal/$(TARGET)

LIB_DIR = $(TOP_DIR)/lib

VPATH = $(BOOT_DIR) $(HAL_TARGET_DIR) $(LIB_DIR)
INC_PATH = -I$(INC_DIR) -I$(HAL_DIR) -I$(HAL_TARGET_DIR) -I$(LIB_DIR)
## Sources and Objects information

ASRCS = $(notdir $(wildcard $(BOOT_DIR)/*.S))
AOBJS = $(patsubst %.S, $(OUTPUT_DIR)/%.os, $(ASRCS))

CSRCS = $(notdir $(wildcard $(BOOT_DIR)/*.c))
CSRCS += $(notdir $(wildcard $(HAL_TARGET_DIR)/*.c))
CSRCS += $(notdir $(wildcard $(LIB_DIR)/*.c))

COBJS = $(patsubst %.c, $(OUTPUT_DIR)/%.o, $(CSRCS))

OBJS = $(AOBJS) $(COBJS)


## Target output information
TARGET_AXF = $(TARGET).axf
TARGET_BIN = $(TARGET).bin
TARGET_DUMP = $(TARGET).dump
TARGET_MAP = $(TARGET).map

## Command
.PHONY: all clean dump qemu gdb

all: $(TARGET_AXF)

$(TARGET_AXF): $(OBJS)
	$(CC) -n -T $(LK_SCRIPT) -Wl,-Map=$(TARGET_MAP) -o $@ $^ $(LDFLAGS)
	$(OC) $(OCFLAGS) $@ $(TARGET_BIN)
	$(DUMP) $(DUMPFLAGS) $@ > $(TARGET).dump

$(OUTPUT_DIR)/%.os: %.S
	@echo "**************ASM_COMPILE**************"
	mkdir -p $(OUTPUT_DIR)
	$(CC) $(CFLAGS) $(INC_PATH) -o $@ $<

$(OUTPUT_DIR)/%.o: %.c
	@echo "**************C_COMPILE**************"
	mkdir -p $(OUTPUT_DIR)
	$(CC) $(CFLAGS) $(INC_PATH) -o $@ $<

qemu:
	qemu-system-arm -M $(BOARD) -kernel $(TARGET_AXF) -nographic

gdb:
	gdb-multiarch $(TARGET_AXF)

clean:
	rm -rf $(OUTPUT_DIR) $(TARGET).*

## qemu-system-arm -M $(BOARD) -kernel $(TARGET_AXF) -nographic -S -gdb tcp::1234,ipv4