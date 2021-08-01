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

import com.example.isteappbackend.R;
import com.example.isteappbackend.TasksUI;

public class HomeFragment extends Fragment implements View.OnClickListener {

//    private HomeViewModel homeViewModel;
//    private FragmentHomeBinding binding;
    Intent tasks;
    @Override
    public void onCreate(@Nullable  Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
         tasks=new Intent(getActivity(), TasksUI.class);

    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view=inflater.inflate(R.layout.fragment_home,container,false);
        Button tasksButton=view.findViewById(R.id.tasksButton);
        tasksButton.setOnClickListener(this);
        return view;
    }

    @Override
    public void onDestroyView() {
        Log.i("mine","View destroyed");
        super.onDestroyView();

//        binding = null;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case(R.id.tasksButton):
//                startActivity(tasks);
        }
    }
}