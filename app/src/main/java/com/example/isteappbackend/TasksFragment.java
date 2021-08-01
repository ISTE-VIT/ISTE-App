package com.example.isteappbackend;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import com.google.android.material.appbar.AppBarLayout;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

public class TasksFragment extends Fragment implements View.OnClickListener {
    View view;
    RecyclerView recyclerView;
    TasksAdapter tasksAdapter;
    Map<String,Task> tasks=new HashMap<>();
    FirebaseDatabase mDatabase;
    DatabaseReference taskDBref;
    ChildEventListener mListener;
    FloatingActionButton taskAddButton;
    static ViewGroup vg;
    Boolean viewing;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        viewing=false;
        mDatabase=FirebaseDatabase.getInstance();
        taskDBref=mDatabase.getReference().child("Tasks");
        tasksAdapter=new TasksAdapter(getActivity(),tasks);
        mListener= new ChildEventListener() {
            @Override
            public void onChildAdded(@NonNull @NotNull DataSnapshot snapshot, @Nullable @org.jetbrains.annotations.Nullable String previousChildName) {
                tasks.put(snapshot.getKey(),snapshot.getValue(Task.class));
                if(viewing){
                    tasksAdapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onChildChanged(@NonNull @NotNull DataSnapshot snapshot, @Nullable @org.jetbrains.annotations.Nullable String previousChildName) {
                tasks.put(snapshot.getKey(),snapshot.getValue(Task.class));
                if(viewing){
                    tasksAdapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onChildRemoved(@NonNull @NotNull DataSnapshot snapshot) {
                tasks.put(snapshot.getKey(),snapshot.getValue(Task.class));
                if(viewing){
                    tasksAdapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onChildMoved(@NonNull @NotNull DataSnapshot snapshot, @Nullable @org.jetbrains.annotations.Nullable String previousChildName) {

            }

            @Override
            public void onCancelled(@NonNull @NotNull DatabaseError error) {

            }
        };
        taskDBref.addChildEventListener(mListener);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        viewing=true;
        view=inflater.inflate(R.layout.fragment_tasks,container,false);
        FloatingActionButton addTask=view.findViewById(R.id.add_task_button);
        recyclerView=view.findViewById(R.id.tasks_recycler);
        recyclerView.setAdapter(tasksAdapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        AppBarLayout appBar=view.findViewById(R.id.appbar);
        vg=(ViewGroup )view.findViewById(android.R.id.content);
        addTask.setOnClickListener(this);
        return view;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case(R.id.add_task_button):
                AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
                builder.setTitle("New Taks");
                View diagInflated=LayoutInflater.from(getActivity()).inflate(R.layout.task_input_dialog,(ViewGroup)view.findViewById(R.id.content),false);
                EditText taskTitleIP,descIP,dateIP,assignedIP;
                taskTitleIP=diagInflated.findViewById(R.id.TaskTitleIP);
                descIP=diagInflated.findViewById(R.id.TaskDescriptionIP);
                dateIP=diagInflated.findViewById(R.id.TaskDueDateIP);
                assignedIP=diagInflated.findViewById(R.id.TaskAssignedIP);
                builder.setPositiveButton("Add task", null);
                builder.setNegativeButton("Cancel",null);
                builder.setView(diagInflated);
                AlertDialog dialog=builder.create();
                dialog.show();
                dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        String title=taskTitleIP.getText().toString(),
                                description=descIP.getText().toString(),
                                date=dateIP.getText().toString(),
                                assigned=assignedIP.getText().toString();
                        //TODO: Input validation
                        Task newTask=new Task(title,description,assigned,date);
                         taskDBref.push().setValue(newTask);
                         dialog.dismiss();

                    }
                });
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        viewing=false;
    }

    //TODO:Make back button go back to the home fragment
}