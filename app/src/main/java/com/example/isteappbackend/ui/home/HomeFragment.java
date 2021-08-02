package com.example.isteappbackend.ui.home;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.navigation.Navigation;

import com.example.isteappbackend.MainActivity2;
import com.example.isteappbackend.R;

public class HomeFragment extends Fragment implements View.OnClickListener {

    View view;
    @Override
    public void onCreate(@Nullable  Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        view=inflater.inflate(R.layout.fragment_home,container,false);
        Button tasksButton=view.findViewById(R.id.tasksButton);
        tasksButton.setOnClickListener(this);
        return view;
    }

    @Override
    public void onDestroyView() {

        Log.i("mine","View destroyed");
        super.onDestroyView();
    }
    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case(R.id.tasksButton):
                Navigation.findNavController(view).navigate(R.id.action_navigation_home_to_tasksFragment);
        }
    }
}