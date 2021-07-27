package com.example.isteappbackend;

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
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.ArrayList;
import java.util.List;

public class TasksUI extends AppCompatActivity implements View.OnClickListener {
    RecyclerView recyclerView;
    TasksAdapter tasksAdapter;
    List<Task> tasks=new ArrayList<>();
    FirebaseDatabase mDatabase;
    DatabaseReference taskDBref;
    FloatingActionButton taskAddButton;

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
        Task t=new Task("Task 1", "Desc 1", "P1", "Date 1");
        tasks.add(t);
        tasksAdapter=new TasksAdapter(this,tasks);
        recyclerView.setAdapter(tasksAdapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
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
                //TODO: Input validation
                builder.setPositiveButton("Add Task", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //the onclick here is overridden and taken over by the dialog coming up next
                    }
                });
                builder.setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.cancel();
                    }
                });
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

                        Task newTask=new Task(title,description,assigned,date);
                        taskDBref.push().setValue(newTask);
                        dialog.dismiss();
                    }
                });
        }
    }
}