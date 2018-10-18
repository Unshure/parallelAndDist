CXX=clang++ -m64
CXXFLAGS=-Iobjs/ -O3 -Wall
ISPC=ispc
ISPCFLAGS=-O2 --arch=x86-64 --target=sse2

default: crack

.PHONY: dirs clean
.PRECIOUS: objs/crack.h

dirs:
	/bin/mkdir -p objs/

clean:
	/bin/rm -rf objs *~ crack

crack: dirs  objs/password_crack.o objs/crack_ispc.o
	$(CXX) $(CXXFLAGS) -o $@ objs/password_crack.o objs/crack_ispc.o

objs/password_crack.o: password_crack.cpp objs/crack_ispc.h 
	$(CXX) $(CXXFLAGS) -c -o $@ $<

objs/%_ispc.h objs/%_ispc.o: %.ispc
	$(ISPC) $(ISPCFLAGS) $< -o objs/$*_ispc.o -h objs/$*_ispc.h