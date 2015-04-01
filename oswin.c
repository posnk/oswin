/**
 * getty.c
 *
 * Part of P-OS getty
 *
 * Written by Peter Bosch <peterbosc@gmail.com>
 *
 * Changelog:
 * 25-05-2014 - Created
 */

#include "osession.h"
#include "odisplay.h"
#include "owindow.h"
#include "orender.h"
#include "ofbdev.h"
#include "omsg.h"
#include "ovideo.h"
#include "oinput.h"
#include "odecor.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <clara/clara.h>
#include <clara/cinput.h>
#include <termios.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <cairo.h>

void usage(){
}

int evdev_init( const char *dev);

int evdev_poll(int fd);

void oswin_render(cairo_t *cr);

int main(int argc, char *argv[], char *envp[]){
	int m_fd, k_fd;
	cairo_t *cr;
	clara_rect_t s = {0,0,9999,9999};
	fprintf(stderr, "info: oswin 0.01 by Peter Bosch\n");

	if (oswin_fbdev_init("/dev/fb0") == -1)
		return 255;

	if (oswin_display_init("/oswdisp") == -1)
		return 255;

	if ((m_fd = evdev_init("/dev/input/event0")) == -1)
		return 255;

	if ((k_fd = evdev_init("/dev/input/event1")) == -1)
		return 255;

	if (oswin_input_init() == -1)
		return 255;

	oswin_decorator_init();
	oswin_session_init();
	oswin_render_init();
	oswin_window_ginit();

	cr = oswin_get_context();
	oswin_add_damage(s);

	while(oswin_display_poll() != -1) {
		oswin_session_process();
		evdev_poll(m_fd);
		evdev_poll(k_fd);
		oswin_window_order();
		oswin_render(cr);
		oswin_flip_buffers();
		usleep(900);
	}

	return 0;
}

