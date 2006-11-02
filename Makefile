.SUFFIXES:

.SUFFIXES : .ftn .cdk .o

SHELL = /bin/sh

COMPILE = compile

FFLAGS =

CFLAGS =

OPTIMIZ = -O 2

default: absolu

.ftn.o:
	r.compile -arch $(ARCH) -abi $(ABI) $(OPTIMIZ) -opt "=$(FFLAGS)" -src $<

.c.o:
	r.compile -arch $(ARCH) -abi $(ABI) $(OPTIMIZ) -opt "=$(CFLAGS)" -src $<

#.f.o:
#	r.compile -arch $(ARCH) -abi $(ABI) $(OPTIMIZ) -opt "=$(FFLAGS)" -src $<

OBJECTS= \
	 copystx.o 	 critsup.o 	 desire.o 	 dmpdes.o \
	 editfst.o 	 entsort.o 	 exdes.o         fermes.o \
	 fstnol.o        holacar.o       julhr.o 	 ouvred.o \
	 ouvres.o        rewinds.o 	 sautsqi.o 	 sauvdez.o \
	 select.o        setper.o 	 sqicopi.o 	 stdcopi.o \
	 weofile.o       zap.o 	         ip1equiv.o


FICHIERS= \
	 copystx.f 	 critsup.f 	 desire.f 	 dmpdes.f \
	 editfst.f 	 entsort.f 	 exdes.f    	 fermes.f \
	 fstnol.f        holacar.f       julhr.f 	 ouvred.f \
	 ouvres.f        rewinds.f 	 sautsqi.f 	 sauvdez.f \
	 select.f 	 setper.f 	 sqicopi.f 	 stdcopi.f \
	 weofile.f       zap.f 



FTNDECKS= \
	 copystx.ftn 	 critsup.ftn 	 desire.ftn 	 dmpdes.ftn \
	 editfst.ftn 	 entsort.ftn 	 exdes.ftn       fermes.ftn \
	 fstnol.ftn      holacar.ftn	 julhr.ftn 	 ouvred.ftn \
	 ouvres.ftn      rewinds.ftn	 sautsqi.ftn 	 sauvdez.ftn \
	 select.ftn      setper.ftn      sqicopi.ftn 	 stdcopi.ftn \
	 weofile.ftn     zap.ftn         ip1equiv.ftn


COMDECKS= \
	 char.cdk 	 desrs.cdk 	 fiches.cdk 	 key.cdk \
	 lin128.cdk 	 logiq.cdk 	 maxprms.cdk 	 tapes.cdk 


copystx.o:     copystx.ftn     maxprms.cdk     logiq.cdk       desrs.cdk       \
               tapes.cdk       key.cdk         char.cdk        fiches.cdk
critsup.o:     critsup.ftn     maxprms.cdk     desrs.cdk       logiq.cdk       \
               char.cdk        fiches.cdk
desire.o:      desire.ftn      maxprms.cdk     desrs.cdk       lin128.cdk      \
               logiq.cdk       fiches.cdk      char.cdk
dmpdes.o:      dmpdes.ftn      maxprms.cdk     logiq.cdk        desrs.cdk      \
               fiches.cdk      char.cdk        maxprms.cdk
editfst.o:     editfst.ftn     maxprms.cdk     tapes.cdk        fiches.cdk     \
               logiq.cdk       desrs.cdk       key.cdk          char.cdk
entsort.o:     entsort.ftn
exdes.o:       exdes.ftn       maxprms.cdk     desrs.cdk        fiches.cdk
fermes.o:      fermes.ftn      maxprms.cdk     desrs.cdk        key.cdk        \
               char.cdk        tapes.cdk       fiches.cdk
fstnol.o:      fstnol.ftn
holacar.o:     holacar.ftn
julhr.o:       julhr.ftn
ouvred.o:      ouvred.ftn      maxprms.cdk     logiq.cdk        key.cdk        \
               char.cdk        tapes.cdk       fiches.cdk
ouvres.o:      ouvres.ftn      maxprms.cdk     logiq.cdk        key.cdk        \
               char.cdk        tapes.cdk       fiches.cdk
rewinds.o:     rewinds.ftn     lin128.cdk      maxprms.cdk      logiq.cdk      \
               desrs.cdk       tapes.cdk       fiches.cdk       char.cdk
sautsqi.o:     sautsqi.ftn     lin128.cdk      maxprms.cdk      tapes.cdk      \
               logiq.cdk       char.cdk        fiches.cdk
sauvdez.o:     sauvdez.ftn     maxprms.cdk     desrs.cdk        char.cdk       \
               fiches.cdk
select.o:      select.ftn      logiq.cdk       maxprms.cdk      fiches.cdk     \
               desrs.cdk       tapes.cdk
setper.o:      setper.ftn      maxprms.cdk     logiq.cdk        lin128.cdk     \
               desrs.cdk       fiches.cdk
sqicopi.o:     sqicopi.ftn     maxprms.cdk     logiq.cdk        lin128.cdk     \
               fiches.cdk      desrs.cdk       char.cdk         tapes.cdk
stdcopi.o:     stdcopi.ftn     lin128.cdk      maxprms.cdk     logiq.cdk       \
               tapes.cdk       char.cdk        fiches.cdk
weofile.o:     weofile.ftn     lin128.cdk      maxprms.cdk     logiq.cdk       \
               fiches.cdk      char.cdk   
zap.o:         zap.ftn         maxprms.cdk     fiches.cdk      logiq.cdk       \
               desrs.cdk       char.cdk
ip1equiv.o:    ip1equiv.ftn

absolu: $(OBJECTS)
#r.build -o editfst -obj $(OBJECTS) -arch $(ARCH) -abi $(ABI) -librmn rmn_008
	r.build -o editfst -obj $(OBJECTS) -arch $(ARCH) -abi $(ABI) -librmn rmnbeta
	
oldstuff: $(OBJECTS)
	r.build -o editfst -obj $(OBJECTS) -arch $(ARCH) -abi $(ABI) -fstd89 -librmn rmnbeta

editfst__: $(OBJECTS)
	r.build -debug -o editfst__  -obj $(OBJECTS) /users/dor/armn/lib/OBJ/Linux/*.o -arch $(ARCH) -abi $(ABI) -librmn rmnbeta

clean:
#Faire le grand menage. On enleve tous les fichiers sources\ninutiles et les .o 
	-if [ "*.ftn" != "`echo *.ftn`" ] ; \
	then \
	for i in *.ftn ; \
	do \
	fn=`r.basename $$i '.ftn'`; \
	rm -f $$fn.f; \
	done \
	fi
	rm *.o editfst
