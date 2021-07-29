package com.example.isteappbackend;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.DialogInterface;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TasksUI extends AppCompatActivity implements View.OnClickListener {
    RecyclerView recyclerView;
    TasksAdapter tasksAdapter;
    Map<String,Task> tasks=new HashMap<>();
    FirebaseDatabase mDatabase;
    DatabaseReference taskDBref;
    ChildEventListener mListener;
    FloatingActionButton taskAddButton;
    static ViewGroup vg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tasks_ui);
        Toolbar toolbar= findViewById(R.id.toolbar);
        toolbar.setTitle("Tasks");
        mDatabase=FirebaseDatabase.getInstance();
        taskDBref= mDatabase.getReference().child("Tasks");
        taskAddButton=findViewById(R.id.add_task_button);
        recyclerView=findViewById(R.id.tasks_recycler);
        taskAddButton.setOnClickListener(this);
        tasksAdapter=new TasksAdapter(this,tasks);
        recyclerView.setAdapter(tasksAdapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        vg=(ViewGroup) findViewById(android.R.id.content);

        mListener=new ChildEventListener() {
            @Override
            public void onChildAdded(@NonNull @NotNull DataSnapshot snapshot, @Nullable @org.jetbrains.annotations.Nullable String previousChildName) {
                tasks.put(snapshot.getKey(),snapshot.getValue(Task.class));
                tasksAdapter.notifyDataSetChanged();
            }

            @Override
            public void onChildChanged(@NonNull @NotNull DataSnapshot snapshot, @Nullable @org.jetbrains.annotations.Nullable String previousChildName) {
                tasks.put(snapshot.getKey(),snapshot.getValue(Task.class));
                tasksAdapter.notifyDataSetChanged();
            }

            @Override
            public void onChildRemoved(@NonNull @NotNull DataSnapshot snapshot) {
                tasks.remove(snapshot.getKey());
                tasksAdapter.notifyDataSetChanged();
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
    public void onClick(View v) {
        switch (v.getId()){
            case (R.id.add_task_button):
                Log.i("mine","Eureka!!(*proceeds to run naked across town*)");
                AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setTitle("New Task");
                View diagInflated= LayoutInflater.from(this).inflate(R.layout.task_input_dialog,(ViewGroup) findViewById(R.id.content),false);
                EditText taskTitleIP,descIP,dateIP,assignedIP;
                taskTitleIP=diagInflated.findViewById(R.id.TaskTitleIP);
                descIP=diagInflated.findViewById(R.id.TaskDescriptionIP);
                dateIP=diagInflated.findViewById(R.id.TaskDueDateIP);
                assignedIP=diagInflated.findViewById(R.id.TaskAssignedIP);
                builder.setPositiveButton("Add Task", null);
                builder.setNegativeButton(android.R.string.cancel, null);
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
}