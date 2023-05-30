
HEADERS=asoundef.h \
conf.h \
control.h \
error.h \
global.h \
hwdep.h \
input.h \
mixer.h \
output.h \
pcm.h \
rawmidi.h \
seq_event.h \
seq.h \
seqmid.h \
seq_midi_event.h \
timer.h \
version.h

HEADERS_PATH=/usr/include/alsa

HEADER_PATHS=$(HEADERS:%=$(HEADERS_PATH)/%)

all: copy-headers patch-headers modules patch-modules

.PHONY: copy-headers
copy-headers:
	mkdir -p headers
	rm -rf headers/*.h
	cp $(HEADER_PATHS) headers/

.PHONY: patch-headers
patch-headers:
	patch -p0 <patches/alsa-headers.patch

.PHONY: modules
modules:
	@command -v dstep >/dev/null 2>&1 || { echo >&2 "dstep utility required in PATH to create D modules."; exit 1; }
	rm -f src/libasound/*.d
	cd headers && dstep -o ../src/libasound --package libasound -include../alsa-includes.h $(HEADERS)
	mv src/libasound/version.d src/libasound/ver.d

.PHONY: patch-modules
patch-modules:
	patch -p0 <patches/modules.patch
