#
# 'make depend' uses makedepend to automatically generate dependencies 
#               (dependencies are added to end of Makefile)
# 'make'        build executable file 'mycc'
# 'make clean'  removes all .o and executable files
#
TARGET=i386-pc-posnk

# define the C compiler to use
CC = @echo " [  CC  ]	" $< ; $(TARGET)-gcc
LD = @echo " [  LD  ]	" $@ ; $(TARGET)-gcc

# define the program name and path
PROGNAME=oswin
PROGPATH=/usr/bin/oswin

# define any compile-time flags
CFLAGS = -Wall -g `pkg-config --cflags --libs cairo`

# define any directories containing header files other than /usr/include
#
INCLUDES = -Iinclude

# define library paths in addition to /usr/lib
#   if I wanted to include libraries not in /usr/lib I'd specify
#   their path using -Lpath, something like:
LFLAGS = 

# define any libraries to link into executable:
#   if I want to link in libraries (libx.so or libx.a) I use the -llibname 
#   option, something like (this will link in libmylib.so and libm.so:
LIBS = -lbmp -lclara `pkg-config --cflags --libs cairo` -lpixman-1 -lm -lfontconfig -lfreetype -lexpat -lpng -lz

# define the C source files
OBJS = $(BUILDDIR)omsg.o \
	$(BUILDDIR)odisplay.o \
	$(BUILDDIR)osession.o \
	$(BUILDDIR)owindow.o \
	$(BUILDDIR)oswin.o \
	$(BUILDDIR)ofbdev.o \
	$(BUILDDIR)oevdev.o \
	$(BUILDDIR)orender.o \
	$(BUILDDIR)odecor.o \
	$(BUILDDIR)oinput.o \
	$(BUILDDIR)ovideo.o \
	$(BUILDDIR)okbd.o \
	$(BUILDDIR)keymap.o

# define the C object files 
#
# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#         For each word in 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .c of all words in the macro SRCS
# with the .o suffix
#
all:	$(BUILDDIR)$(PROGNAME)

$(BUILDDIR)$(PROGNAME): $(OBJS)
	$(LD) $(LFLAGS) -o $(BUILDDIR)$(PROGNAME) $(OBJS) $(LIBS)

install: $(BUILDDIR)$(PROGNAME)
	install $(BUILDDIR)$(PROGNAME) $(DESTDIR)$(PROGPATH)

.PHONY: depend clean

# this is a suffix replacement rule for building .o's from .c's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file) 
# (see the gnu make manual section about automatic variables)
$(BUILDDIR)%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@

clean:
	$(RM) $(BUILDDIR)*.o $(BUILDDIR)*~ $(BUILDDIR)$(PROGNAME)

depend: $(SRCS)
	makedepend $(INCLUDES) $^

# DO NOT DELETE THIS LINE -- make depend needs it

