# Ballerina gRPC Library System

## Overview

gRPC is a powerful tool for building distributed systems, microservices, and APIs. It offers efficiency, performance, multi-language support, and a rich feature set.

## Designing a Library System Using gRPC

In this project, we are designing and implementing a library system using gRPC. The system caters to two types of users: students and librarians, and it provides essential functionalities for managing books, borrowing them, and returning them.

### Add Book

Librarians can create a book with specific details and receive the ISBN for the added book.

### Create Users

This operation allows the creation of multiple users, each with a specific profile. Users are streamed to the server, and the response is sent once the operation completes. This means you can send multiple user profiles to the server in a continuous stream, making data management efficient.

### Server

On the server side, there's code to receive and process incoming users as they arrive in the stream. The server will take each user profile from the stream and perform actions, such as creating user accounts or storing their information in a database.

### Asynchronous

Importantly, the operation is asynchronous. It doesn't wait for all users to be sent and processed before responding. Instead, it starts responding as soon as it completes its part of the operation for each user.

### Update Book

Librarians can edit the details of a given book.

### Remove Book

Librarians can remove a book from the library's collection and return the updated list of books.

### List Available Books

Students can get a list of all available books.

### Locate Book

Students can search for a book based on its ISBN and receive its location if available or be informed if the book is not available.

#### ISBN Query

You have the ISBN (International Standard Book Number) of the book you're looking for.

#### Asking the Library System

You go to a computer or use a library app and enter the ISBN of the book you want.

#### Library System Response

The library server checks its records to see if the book with that ISBN is available in the library. If available, it provides the book's location; otherwise, it informs you that the book is not currently in the library.

### Borrow Book

Students can borrow a book by providing their user ID and the book's ISBN.

## Database Schema

Here is the database schema for the library system:

### Books Table

| Column   | Type                            | Constraints         |
| -------- | ------------------------------- | ------------------- |
| ISBN     | VARCHAR(13)                     | Primary Key (PK)    |
| Title    | VARCHAR(255)                    |                     |
| Author   | VARCHAR(255)                    |                     |
| Location | VARCHAR(255)                    |                     |
| Status   | ENUM('Available', 'CheckedOut') | Default 'Available' |

### Users Table

| Column   | Type                            | Constraints         |
| -------- | ------------------------------- | ------------------- |
| UserID   | INT AUTO_INCREMENT              | Primary Key (PK)    |
| Name     | VARCHAR(255)                    |                     |
| UserType | ENUM('Student', 'Librarian')    |                     |
| Contact  | VARCHAR(255)                    |                     |
| Status   | ENUM('Available', 'CheckedOut') | Default 'Available' |

### Borrowed Books Table

| Column   | Type               | Constraints      |
| -------- | ------------------ | ---------------- |
| BorrowID | INT AUTO_INCREMENT | Primary Key (PK) |
| UserID   | INT                | Foreign Key (FK) |
| ISBN     | VARCHAR(13)        | Foreign Key (FK) |
