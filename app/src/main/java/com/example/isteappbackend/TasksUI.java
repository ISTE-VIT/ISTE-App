package com.example.isteappbackend;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;

public class TasksUI extends AppCompatActivity {
    RecyclerView recyclerView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tasks_ui);
        Toolbar toolbar= findViewById(R.id.toolbar);
        toolbar.setTitle("Tasks");
        recyclerView=findViewById(R.id.tasks_recycler);
        Task t=new Task("Task 1", "Desc 1", "P1", "Date 1");
    }

}