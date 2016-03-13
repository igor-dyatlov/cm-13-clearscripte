#!/bin/bash

zip -r temp ./script/META-INF ./script/system
java -jar ./certificates/signapk.jar ./certificates/testkey.x509.pem ./certificates/testkey.pk8 temp.zip nexusfication-clearscripte-$(date +%F-%H-%M).zip
rm temp.zip
