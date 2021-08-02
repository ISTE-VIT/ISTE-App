package com.example.isteappbackend;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.navigation.Navigation;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

import org.jetbrains.annotations.NotNull;

import java.util.concurrent.Executor;

public class LoginFragment extends Fragment implements View.OnClickListener {

    FirebaseAuth mAuth;
    EditText email_textView,pwd_textView;
    static View view;
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        view=inflater.inflate(R.layout.fragment_login, container, false);
        Button login_button;
        email_textView=view.findViewById(R.id.login_email_ip);
        pwd_textView=view.findViewById(R.id.login_pwd_ip);
        login_button=view.findViewById(R.id.loginButton);
        login_button.setOnClickListener(this);
        mAuth=FirebaseAuth.getInstance();
        MainActivity2.onLogin.setValue(true);
        return view;
    }
    public static void toHome(){
        Log.i("mine","Auth success");
        Navigation.findNavController(view).navigate(R.id.action_loginFragment_to_navigation_home);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        MainActivity2.onLogin.setValue(false);

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case(R.id.loginButton):
                String email=email_textView.getText().toString().trim();
                String password=pwd_textView.getText().toString().trim();
                if(!email.equals("") && !password.equals("")) {
                    mAuth.signInWithEmailAndPassword(email, password)
                            .addOnCompleteListener(getActivity(), new OnCompleteListener<AuthResult>() {
                                @Override
                                public void onComplete(@NonNull @NotNull com.google.android.gms.tasks.Task<AuthResult> task) {
                                    if (task.isSuccessful()) {
                                        // Sign in success, update UI with the signed-in user's information
                                        Log.d("mine", "signInWithEmail:success");
                                    } else {
                                        // If sign in fails, display a message to the user.
                                        Log.w("mine", "signInWithEmail:failure", task.getException());
                                        Toast.makeText(getActivity(), "Login failed", Toast.LENGTH_SHORT).show();

                                    }
                                }

                            });
                }
        }
    }
}