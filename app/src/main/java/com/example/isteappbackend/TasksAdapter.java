package com.example.isteappbackend;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class TasksAdapter extends RecyclerView.Adapter<TasksAdapter.MyViewHolder> {
    List<Task> tasks = new ArrayList<>();
    Context ct;
    public TasksAdapter(Context ct, List<Task> tasks){
        this.ct = ct;
        this.tasks=tasks;
    }
    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        LayoutInflater inflater=LayoutInflater.from(ct);
        //Inflate the row xml file
        View view = inflater.inflate(R.layout.task_row,parent,false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
//        holder.myText1.setText(data1[position]);
        Task t=tasks.get(position);
        holder.title.setText(t.getTitle());
        holder.desc.setText(t.getDescription());
        holder.assignedTo.setText(t.getAssignedTo());
        holder.date.setText(t.getDate());
    }

    @Override
    public int getItemCount() {
//        return data1.length;
        return tasks.toArray().length;
    }


    public class MyViewHolder extends RecyclerView.ViewHolder {
        TextView title,desc,date,assignedTo;
        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            //find view itemview.find
            title=itemView.findViewById(R.id.task_title);
            desc=itemView.findViewById(R.id.task_desc);
            date=itemView.findViewById(R.id.task_date);
            assignedTo=itemView.findViewById(R.id.task_assigned);

        }
    }
}
