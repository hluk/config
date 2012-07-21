#!/bin/sh
export LIBGL_ALWAYS_INDIRECT=1
export INTEL_BATCH=1
exec compiz --sm-disable --indirect-rendering --replace ccp
