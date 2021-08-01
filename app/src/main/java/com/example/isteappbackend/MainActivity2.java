package com.example.isteappbackend;

import android.os.Bundle;
import android.util.Log;

import com.example.isteappbackend.ui.home.HomeFragment;
import com.google.android.material.bottomnavigation.BottomNavigationView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentContainerView;
import androidx.fragment.app.FragmentManager;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.example.isteappbackend.databinding.ActivityMain2Binding;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

import org.jetbrains.annotations.NotNull;

import static android.view.View.GONE;
import static android.view.View.VISIBLE;

public class MainActivity2 extends AppCompatActivity {

    private ActivityMain2Binding binding;
    FirebaseAuth firebaseAuth;
    FirebaseAuth.AuthStateListener mAuthStateListener;
    BottomNavigationView bottomNavigationView;
    Boolean onLoading;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        onLoading=true;
        binding = ActivityMain2Binding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        FragmentContainerView nav=findViewById(R.id.nav_host_fragment_activity_main2);
         bottomNavigationView = findViewById(R.id.nav_view);
        firebaseAuth=FirebaseAuth.getInstance();
        FragmentManager fragmentManager=getSupportFragmentManager();
        fragmentManager.beginTransaction().replace(R.id.nav_host_fragment_activity_main2, LoadingFrag.class,null)
                .addToBackStack(null)
                .commit();
        bottomNavigationView.setVisibility(VISIBLE);

        mAuthStateListener=new FirebaseAuth.AuthStateListener() {
            @Override
            public void onAuthStateChanged(@NonNull @NotNull FirebaseAuth firebaseAuth) {
                FirebaseUser user=firebaseAuth.getCurrentUser();
                if(user!=null){
                    bottomNavigationView.setVisibility(VISIBLE);
                    if (onLoading)
//                        Log.i("mine","Going ")
                        LoadingFrag.toHome();
                    else
                        LoginFragment.toHome();
                    // Passing each menu ID as a set of Ids because each
                    // menu should be considered as top level destinations.
                    FragmentManager fragmentManager=getSupportFragmentManager();
                    fragmentManager.beginTransaction().replace(R.id.nav_host_fragment_activity_main2, HomeFragment.class,null)
                            .addToBackStack(null)
                            .commit();

                    AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(
                            R.id.navigation_home, R.id.navigation_dashboard, R.id.navigation_notifications)
                            .build();
                    NavController navController = Navigation.findNavController(MainActivity2.this, R.id.nav_host_fragment_activity_main2);

                    NavigationUI.setupActionBarWithNavController(MainActivity2.this, navController, appBarConfiguration);
                    NavigationUI.setupWithNavController(binding.navView, navController);
                }
                else{
                    Log.i("mine","not logged in");
                    onLoading=false;
                    LoadingFrag.toLogin();
                }
            }
        };
    }

    @Override
    protected void onPause() {
        super.onPause();
        firebaseAuth.removeAuthStateListener(mAuthStateListener);
        bottomNavigationView.setVisibility(GONE);
    }

    @Override
    protected void onResume() {
        super.onResume();
        firebaseAuth.addAuthStateListener(mAuthStateListener);
    }
}