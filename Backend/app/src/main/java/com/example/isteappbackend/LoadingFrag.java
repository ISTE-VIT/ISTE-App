package com.example.isteappbackend;

import android.content.Context;
import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.navigation.Navigation;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class LoadingFrag extends Fragment {
    static View view;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        view=inflater.inflate(R.layout.fragment_loading, container, false);

        return view;
    }

    public static void toLogin(){
        Navigation.findNavController(view).navigate(R.id.action_loadingFrag_to_loginFragment);
    }public static void toHome(){
        Navigation.findNavController(view).navigate(R.id.action_loadingFrag_to_navigation_home);
    }
}