JDK := $(realpath ./jdk-16.0.2)
JAVA := $(JDK)/bin/java
JAVAC := $(JDK)/bin/javac
JAR := $(JDK)/bin/jar

CLEANFILES := Main.class fun/FunProcessor.class dep.jar

all: run

Main.class: Main.java dep.jar
	$(JAVAC) -cp dep.jar Main.java

%.class: %.java
	$(JAVAC) $<

dep.jar: MANIFEST.MF fun/FunProcessor.class
	install -DT fun/FunProcessor.class res/fun/FunProcessor.class
	(cd res; $(JAR) -c -f ../$@ -m  ../MANIFEST.MF **/*)

run: Main.class dep.jar
	$(JAVA) -cp .:dep.jar -Djava.security.manager -Djava.security.policy==/dev/null Main

.PHONY: clean

clean:
	rm -f $(CLEANFILES)
