#
#  Copyright (c) 2019            Jeong Han Lee
#  Copyright (c) 2018 - 2019     European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Thursday, March 28 22:32:11 CET 2019
# version : 0.0.2
#
## The following lines are mandatory, please don't change them.
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS



ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif

ifneq ($(strip $(ADCORE_DEP_VERSION)),)
ADCore_VERSION=$(ADCORE_DEP_VERSION)
endif


APP:=NDDriverStdArraysApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src


# USR_INCLUDES += -I$(where_am_I)$(APPSRC)

# USR_CFLAGS   += -Wno-unused-variable
# USR_CFLAGS   += -Wno-unused-function
# USR_CFLAGS   += -Wno-unused-but-set-variable
# USR_CPPFLAGS += -Wno-unused-variable
# USR_CPPFLAGS += -Wno-unused-function
# USR_CPPFLAGS += -Wno-unused-but-set-variable

# We have to convert all to db 
TEMPLATES += $(wildcard $(APPDB)/*.db)

HEADERS += $(APPSRC)/NDDriverStdArrays.h
SOURCES += $(APPSRC)/NDDriverStdArrays.cpp
DBDS    += $(APPSRC)/NDDriverStdArraysSupport.dbd



USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)
USR_DBFLAGS += -I $(E3_SITEMODS_PATH)/ADCore/$(ADCORE_DEP_VERSION)/db

SUBS=$(wildcard $(APPDB)/*.substitutions)
TMPS=$(wildcard $(APPDB)/*.template)


db: $(SUBS) $(TMPS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@


.PHONY: db $(SUBS) $(TMPS)

vlibs:

.PHONY: vlibs
