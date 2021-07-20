package com.example.iste;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.Toast;

public class LoginScreen extends AppCompatActivity {

    public void Login(View view) {
        login();
    }

    private void login() {
        EditText enteredEmail = (EditText)findViewById(R.id.email);
        final String email = enteredEmail.getText().toString();
        EditText enteredPassword = (EditText)findViewById(R.id.password);
        final String password = enteredPassword.getText().toString();

        Toast.makeText(getApplicationContext(), email + password, Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_login_screen);
    }
}