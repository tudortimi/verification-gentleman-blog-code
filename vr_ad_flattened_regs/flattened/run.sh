#!/bin/bash

ref_model="ref_model$1"

specman -c "load regs; load $ref_model; test" -log "specman_$ref_model.elog"
