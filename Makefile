BASEDIR	:= $(dir $(firstword $(MAKEFILE_LIST)))
VPATH	:= $(BASEDIR)

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing header files
# ROMFS is a folder to generate app's romfs
#---------------------------------------------------------------------------------
TARGET		:=	WiiU-Shell
SOURCES		:=	source source/audio source/menus source/minizip source/menus/menu_book_reader
INCLUDES    :=	include include/audio include/menus include/minizip
ROMFS		:=	romfs
include $(WUT_ROOT)/share/romfs-wiiu.mk

VERSION_MAJOR := 1
VERSION_MINOR := 0
VERSION_MICRO := 4

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
COMMFLAGS	:=	-O2 -Wall -Wno-format-truncation -U__STRICT_ANSI__ \
				-DVERSION_MAJOR=$(VERSION_MAJOR) -DVERSION_MINOR=$(VERSION_MINOR) -DVERSION_MICRO=$(VERSION_MICRO)
CFLAGS		+=	$(COMMFLAGS) -std=c11 
CXXFLAGS	+=	$(COMMFLAGS)
LDFLAGS		+=	$(WUT_NEWLIB_LDFLAGS) $(WUT_STDCPP_LDFLAGS) $(WUT_DEVOPTAB_LDFLAGS) $(ROMFS_LDFLAGS) \
				-lcoreinit -lvpad -lsndcore2 -lsysapp -lproc_ui -lgx2 -lgfd -lzlib125 -lwhb \
				-lg -lfreetype -lpng -ljpeg -lzip -lmad -lvorbisidec -logg \
				-lSDL2_ttf -lSDL2_gfx -lSDL2_image -lSDL2 -lSDL2_mixer

#---------------------------------------------------------------------------------
# get a list of objects
#---------------------------------------------------------------------------------
INCLUDE		:=	$(foreach dir,$(INCLUDES),-I$(dir))
CFILES		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
SFILES		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.s))
OBJECTS		:=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o) $(ROMFS_TARGET)
CFLAGS		+=	$(INCLUDE)
CXXFLAGS	+=	$(INCLUDE)

#---------------------------------------------------------------------------------
# objectives
#---------------------------------------------------------------------------------
$(TARGET).rpx: $(OBJECTS)

clean:
	@echo CLEAN ...
	@rm -rf $(TARGET).rpx $(TARGET).rpx.elf $(OBJECTS) $(OBJECTS:.o=.d)

#---------------------------------------------------------------------------------
# wut and portlibs
#---------------------------------------------------------------------------------
include $(WUT_ROOT)/share/wut.mk
PORTLIBS	:=	$(DEVKITPRO)/portlibs/ppc
LDFLAGS		+=	-L$(PORTLIBS)/lib
CFLAGS		+=	-I$(PORTLIBS)/include -I$(PORTLIBS)/include/SDL2
CXXFLAGS	+=	-I$(PORTLIBS)/include -I$(PORTLIBS)/include/SDL2