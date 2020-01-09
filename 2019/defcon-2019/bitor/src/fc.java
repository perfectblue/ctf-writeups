package ooo.vitor;

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
import android.webkit.WebView;
import android.net.Uri;
import dalvik.system.DexClassLoader;
import java.io.File;
import android.content.Context;

public class fc
{
    private static final byte[] initVector;
    public static boolean mValid = false;
    public static String p1EncFn = "ckxalskuaewlkszdva";
    public static String p1Fn = "nsavlkureaasdqwecz";
    public static String p5EncFn = "cxnvhaekljlkjxxqkq";
    public static String rand2EncFn = "fwswzofqwkzhsgdxfr";
    public static String randEncFn = "zslzrfomygfttivyac";
    
    static {
        initVector = new byte[] { 19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55, 19, 55 };
    }
    
    public fc() {
        super();
    }
    
    private static boolean cf(final Context context, final File file, final String s) {
        final File file2 = new File(context.getFilesDir().getAbsolutePath());
        final DexClassLoader dexClassLoader = new DexClassLoader(file.getAbsolutePath(), file2.getAbsolutePath(), file2.getAbsolutePath(), ClassLoader.getSystemClassLoader());
        final boolean b = false;
        try {
            final Class loadClass = dexClassLoader.loadClass("ooo.p1.P1");
            return (boolean)loadClass.getDeclaredMethod("cf", Context.class, String.class).invoke(loadClass, context, s);
        }
        catch (Exception ex) {
            return b;
        }
    }
    
    public static boolean cf(final MainActivity mainActivity, final String s) {
        try {
            cfa((Context)mainActivity, fc.p1EncFn);
            cfa((Context)mainActivity, fc.p5EncFn);
            cfa((Context)mainActivity, fc.randEncFn);
            cfa((Context)mainActivity, fc.rand2EncFn);
            if (s.startsWith("OOO{") && s.endsWith("}")) {
                if (s.length() == 45) {
                    if (!cf((Context)mainActivity, dp1((Context)mainActivity, new File(mainActivity.getFilesDir(), fc.p1EncFn), g0(s.substring(4, 44))), s)) {
                        return false;
                    }
                    final File file = new File(mainActivity.getFilesDir(), "bam.html");
                    final WebView mWebView = mainActivity.mWebView;
                    final StringBuilder sb = new StringBuilder();
                    sb.append("file:///");
                    sb.append(file.getAbsolutePath());
                    sb.append("?flag=");
                    sb.append(Uri.encode(s));
                    mWebView.loadUrl(sb.toString());
                    return fc.mValid;
                }
            }
            return false;
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
    
    private static void copyFile(final File file, final File file2) throws Exception {
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
    
    private static File dp1(final Context context, final File file, byte[] hash) throws Exception {
        hash = hash(hash);
        final byte[] allBytes = Files.readAllBytes(file.toPath());
        try {
            final IvParameterSpec params = new IvParameterSpec(fc.initVector);
            final SecretKeySpec key = new SecretKeySpec(hash, "AES");
            final Cipher instance = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            instance.init(2, key, params);
            final byte[] doFinal = instance.doFinal(allBytes);
            final File file2 = new File(context.getFilesDir(), fc.p1Fn);
            final FileOutputStream fileOutputStream = new FileOutputStream(file2);
            fileOutputStream.write(doFinal, 0, doFinal.length);
            fileOutputStream.flush();
            fileOutputStream.close();
            return file2;
        }
        catch (Exception ex) {
            return null;
        }
    }
    
    public static byte[] g0(final String s) {
        final byte[] array = new byte[4];
        final byte[] bytes = s.getBytes();
        for (int i = 0; i < 4; ++i) {
            array[i] = 0;
        }
        for (int j = 0; j < 10; ++j) {
            for (int k = 0; k < 4; ++k) {
                array[k] ^= bytes[j * 4 + k];
            }
        }
        return array;
    }
    
    public static byte[] hash(final byte[] input) throws Exception {
        final MessageDigest instance = MessageDigest.getInstance("MD5");
        instance.update(input);
        return instance.digest();
    }
}
