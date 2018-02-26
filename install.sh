#!/bin/bash
clear

#
# Copyright (C) 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Current directory represents the directory where this script has been called.
# Root directory represents the directory where this script is located.
CRDIR=$(pwd)
RTDIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
FSTMP="$FSDIR/.tmp"

zip -r temp bullhead flo hammerhead maguro sailfish META-INF
java -jar ./certificates/signapk.jar ./certificates/testkey.x509.pem ./certificates/testkey.pk8 temp.zip pixelization-clearscripte-2.0.1-aroma-$(date +%F-%H-%M).zip

sign_flashable()
{
	# This function expects both a configuration to be loaded and
	# an argument to be passed.
	(config_loaded) || terminate "3" "Bake configuration"
	[ ! -z $1 ] || terminate "1"

	# Check the presence of the required files.
	[ -f $SADIR/signapk.jar ] && [ -f $SADIR/keys/*.pk8 ] &&
	[ -f $SADIR/keys/*.pem ] && [ -f $FSTMP/$1 ] || return 1

	print "${CYACL}- Signing $1 archive..."

	# Setup private and public keys.
	PVKEY=$(find $SADIR/keys/*.pk8 | head -1)
	PBKEY=$(find $SADIR/keys/*.pem | head -1)

	# Sign a target flashable archive with previously set keys.
	java -jar $SADIR/signapk.jar $PBKEY $PVKEY $FSTMP/$1 $SADIR/$1

	# Move a signed archive back to the source.
	mv -f $SADIR/$1 $FSTMP/$1

	print "${GRNCL}- $1 was successfully signed!"
}

# Remove temporary flashable directory as it will be overwritten anyway.
rm -rf $FSTMP
rm temp.zip
