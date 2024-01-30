FLASHIC = SST39SF040
PROJ = main
# Add Windows and Unix support
RM         = rm -rf
COPY       = cp -a
PATH_SEP   = /

all: ${PROJ}.bin

flash: ${PROJ}.bin
	minipro -p ${FLASHIC} -w ${PROJ}.bin -s

${PROJ}.bin: ${PROJ}.o machine.cfg
	ld65 -C machine.cfg ${PROJ}.o -o ${PROJ}.bin

${PROJ}.o: ${PROJ}.s
	ca65 --cpu 65C02 ${PROJ}.s

clean:
	$(RM) ${PROJ}.bin ${PROJ}.o

.PHONY: prog clean
