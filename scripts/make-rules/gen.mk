# Copyright 2020 Lingfei Kong <colin404@foxmail.com>. All rights reserved.    
# Use of this source code is governed by a MIT style    
# license that can be found in the LICENSE file.

# ==============================================================================
# Makefile helper functions for generate necessary files
#


CAS=iam-apiserver iam-authz-server admin

.PHONY: gen.run
gen.run: gen.errcode 

.PHONY: gen.errcode
gen.errcode: gen.errcode.code gen.errcode.doc

.PHONY: gen.errcode.code
gen.errcode.code:
	@echo "===========> Generating iam error code go source files" 
	@$(GO) run ${ROOT_DIR}/tools/codegen/codegen.go -type=int ${ROOT_DIR}/internal/pkg/code

.PHONY: gen.errcode.doc
gen.errcode.doc:
	@echo "===========> Generating error code markdown documentation" 
	@$(GO) run ${ROOT_DIR}/tools/codegen/codegen.go -type=int -doc \
		-output ${ROOT_DIR}/docs/guide/zh-CN/api/error_code.md ${ROOT_DIR}/internal/pkg/code

.PHONY: gen.ca.%
gen.ca.%:
	$(eval CA := $(word 1,$(subst ., ,$*)))
	@echo "===========> Generating CA files for $(CA)" 
	@${ROOT_DIR}/scripts/gencerts.sh generate-iam-cert $(OUTPUT_DIR)/cert $(CA)
#@${ROOT_DIR}/scripts/gencerts.sh create-iam-certs $(CA)

.PHONY: gen.ca
gen.ca: $(addprefix gen.ca., $(CAS))