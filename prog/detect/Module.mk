#  Module.mk - Makefile for a Linux module for reading sensor data.
#  Copyright (c) 1998, 1999  Frodo Looijaard <frodol@dds.nl>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# Note that MODULE_DIR (the directory in which this file resides) is a
# 'simply expanded variable'. That means that its value is substituted
# verbatim in the rules, until it is redefined. 
MODULE_DIR := prog/detect
PROGDETECTDIR := $(MODULE_DIR)

# Regrettably, even 'simply expanded variables' will not put their currently
# defined value verbatim into the command-list of rules...
PROGDETECTTARGETS := $(MODULE_DIR)/i2cdetect $(MODULE_DIR)/dmidecode
PROGDETECTSOURCES := $(MODULE_DIR)/i2cdetect.c $(MODULE_DIR)/dmidecode.c
PROGDETECTSBININSTALL := $(MODULE_DIR)/sensors-detect \
                         $(MODULE_DIR)/i2cdetect

# Include all dependency files. We use '.rd' to indicate this will create
# executables.
INCLUDEFILES += $(PROGDETECTSOURCES:.c=.rd)

all-prog-detect: $(PROGDETECTTARGETS)
user :: all-prog-detect

$(MODULE_DIR)/i2cdetect: $(MODULE_DIR)/i2cdetect.ro prog/dump/i2cbusses.ro
	$(CC) -o $@ $^

install-prog-detect: all-prog-detect
	mkdir -p $(DESTDIR)$(SBINDIR)
	$(INSTALL) -o root -g root -m 755 $(PROGDETECTSBININSTALL) $(DESTDIR)$(SBINDIR)
	if [ ! -e $(DESTDIR)$(SBINDIR)/dmidecode -o $(DESTDIR)$(SBINDIR)/dmidecode -ot $(PROGDETECTDIR)/dmidecode.c ] ; then \
	  $(INSTALL) -o root -g root -m 755 $(PROGDETECTDIR)/dmidecode $(DESTDIR)$(SBINDIR) ; \
	fi
user_install :: install-prog-detect

clean-prog-detect:
	$(RM) $(PROGDETECTDIR)/*.rd $(PROGDETECTDIR)/*.ro $(PROGDETECTTARGETS)
clean :: clean-prog-detect
