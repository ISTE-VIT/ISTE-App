package com.example.isteappbackend;

public class Task {
    String title,description,assignedTo,dueDate;
    Task(String title, String description, String assignedTo, String dueDate){
        this.title = title;
        this.description = description;
        this.assignedTo=assignedTo;
        this.dueDate=dueDate;
    }

    String getTitle(){return title;}
    String getDescription(){return description;}
    String getAssignedTo(){return assignedTo;}
    String getDate(){return dueDate;}

}
