# Install and build the Loopy system
# Please customize settings in the section immediately below. 

# =========================== Customize =========================== 

# Loopy root directory
ROOT_DIR=$(PWD)

# Number of processors to run make on 
PAR_BUILD=4


# =========================== Derived =========================== 
# LLVM root directory
LLVM_DIR=${ROOT_DIR}/llvm
LLVM_BUILD_DIR=${LLVM_DIR}/build

# Loopy source directory
SRC_DIR=${ROOT_DIR}/src

# Tests directory
TESTS_DIR=${ROOT_DIR}/tests

# =========================== Build rules =========================== 
.PHONY: all get_llvm get_clang get_loopy build test

all: build

${LLVM_DIR}/build:
	mkdir -p $@

${LLVM_DIR}/trunk: ${LLVM_DIR}/build
	(test -e $@ || svn co -r 241394 http://llvm.org/svn/llvm-project/llvm/trunk $@)
	 touch $@

# install LLVM, require specific version
get_llvm: ${LLVM_DIR}/trunk

${LLVM_DIR}/trunk/tools/clang: ${LLVM_DIR}/trunk
	 (test -e $@ || svn co -r 241394 http://llvm.org/svn/llvm-project/cfe/trunk $@)
	 touch $@

get_clang: ${LLVM_DIR}/trunk/tools/clang

# copy Loopy code
${LLVM_DIR}/trunk/tools/polly: ${LLVM_DIR}/trunk
	@(test -e $@ || ln -s ${SRC_DIR}/ ${LLVM_DIR}/trunk/tools/polly)

get_loopy: ${LLVM_DIR}/trunk/tools/polly

${LLVM_DIR}/trunk/Makefile: get_loopy get_clang get_llvm
	(test -e $@ || (cd ${LLVM_BUILD_DIR}; cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX=${LLVM_DIR} ${LLVM_DIR}/trunk))

# build LLVM + loopy
build: get_loopy get_clang get_llvm ${LLVM_DIR}/trunk/Makefile
	(cd ${LLVM_BUILD_DIR}; $(MAKE) -j ${PAR_BUILD})


# =========================== Test =========================== 
# run Loopy tests
test: 
	cd ${TESTS_DIR}; \
	sh clean-up.sh; \
	sh run-all-tests.sh ${LLVM_BUILD_DIR}

