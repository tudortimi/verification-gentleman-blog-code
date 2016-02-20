#!/bin/bash

test="test$1"

specman -c "load e/$test; test" -log "test$1.elog"
