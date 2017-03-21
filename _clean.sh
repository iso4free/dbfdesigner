#!/bin/bash
rm *.bak
rm *.a
rm *.o
rm *.or
rm *.ppu
rm *.compiled

strip dbdesigner
upx dbdesigner