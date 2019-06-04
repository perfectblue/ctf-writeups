package ooo.defcon2019.quals.veryandroidoso;

import android.view.View;
import android.view.View$OnClickListener;
import android.widget.EditText;
import android.widget.Button;
import android.os.Bundle;
import java.util.regex.Pattern;
import android.util.Log;
import android.content.Context;
import android.widget.Toast;
import android.app.Activity;

public class MainActivity extends Activity
{
    public static final String TAG = "veryandroidoso";
    
    public MainActivity() {
        super();
    }
    
    static /* synthetic */ int[] access$000(final MainActivity mainActivity, final String s) {
        return mainActivity.parse(s);
    }
    
    static /* synthetic */ void access$100(final MainActivity mainActivity) {
        mainActivity.win();
    }
    
    static /* synthetic */ void access$200(final MainActivity mainActivity) {
        mainActivity.fail();
    }
    
    private void fail() {
        Toast.makeText((Context)this, (CharSequence)"Fail!", 1).show();
        Log.i("veryandroidoso", "Fail!");
    }
    
    private int[] parse(final String s) {
        if (s.length() != 23) {
            return null;
        }
        if (!s.startsWith("OOO{")) {
            return null;
        }
        if (!s.endsWith("}")) {
            return null;
        }
        final String substring = s.substring(4, s.length() - 1);
        if (!substring.toLowerCase().equals(substring)) {
            return null;
        }
        if (!Pattern.compile("^\\p{XDigit}+$").matcher(substring).matches()) {
            return null;
        }
        final int[] array = new int[9];
        int n;
        for (int i = 0; i < substring.length() / 2; i = n) {
            n = i + 1;
            array[i] = Integer.parseInt(substring.substring(i * 2, n * 2), 16);
        }
        return array;
    }
    
    private void win() {
        Toast.makeText((Context)this, (CharSequence)"Success!", 1).show();
        Log.i("veryandroidoso", "Success!");
    }
    
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);
        this.setContentView(2131099648);
        Log.i("veryandroidoso", "started!");
        Solver.cc = (Context)this;
        final Button button = (Button)this.findViewById(2131034114);
        final EditText editText = (EditText)this.findViewById(2131034118);
        button.setOnClickListener((View$OnClickListener)new View$OnClickListener() {
            final /* synthetic */ MainActivity this$0;
            final /* synthetic */ EditText val$et;
            
            MainActivity$1() {
                this.this$0 = this$0;
                super();
            }
            
            public void onClick(final View view) {
                final int[] access$000 = MainActivity.this.parse(editText.getText().toString());
                if (access$000 != null) {
                    if (Solver.solve(access$000[0], access$000[1], access$000[2], access$000[3], access$000[4], access$000[5], access$000[6], access$000[7], access$000[8])) {
                        MainActivity.this.win();
                    }
                    else {
                        MainActivity.this.fail();
                    }
                    this.this$0.finish();
                    return;
                }
                MainActivity.this.fail();
                this.this$0.finish();
            }
        });
        final String stringExtra = this.getIntent().getStringExtra("flag");
        if (stringExtra != null) {
            if (Solver.sleep(3000) < 3000L) {
                this.fail();
                this.finish();
                return;
            }
            editText.setText((CharSequence)stringExtra);
            button.performClick();
        }
    }
}
