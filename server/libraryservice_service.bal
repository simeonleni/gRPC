import ballerina/grpc;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/io;

// import ballerina/sql;

type Books record {
    string isbn;
    string title;
    string author;
    string location;
    string status;
};

final mysql:Client libraryClient = check new (
    host = "first-instance.cg4vktva35w7.eu-north-1.rds.amazonaws.com",
    user = "learning", password = "learning-db",
    port = 3306,
    database = "library"
);

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: LIBRARY_DESC}
service "LibraryService" on ep {

    remote function AddBook(AddBookRequest value) returns AddBookResponse|error {
        _ = check libraryClient->execute(`INSERT INTO Books(ISBN, Title, Author, Location, Status)
             VALUES (${value.book.isbn}, ${value.book.title}, ${value.book.author}, ${value.book.location}, ${value.book.status})`);
        return {isbn: value.book.isbn};
    }
    remote function UpdateBook(UpdateBookRequest value) returns UpdateBookResponse|error {
        // string[] keys = [];
        // string[] values = [];

        var data = {
            ISBN: value.book.isbn,
            Title: value.book.title,
            Author: value.book.author,
            Location: value.book.location,
            Status: value.book.status
        };

        // foreach var item in data {
        //     if (item != "") {
        //         keys.push(data.keys().toString());
        //         values.push(item);
        //     }
        // }
        // foreach var key in keys {
        //     int index = keys.indexOf(key) ?: 0;
        //     if (index >= 0 && index < values.length()) {
        //         string datum = values[index].trim();
        //         _ = check libraryClient->execute(`UPDATE Books SET ${key.trim()} = '${datum}' WHERE ISBN='${data.ISBN}'`);
        //     }
        // }
        _ = check libraryClient->execute(`UPDATE Books SET Title =  ${data.Title}, Author = ${data.Author}, Location = ${data.Location}, Status = ${data.Status} WHERE ISBN=${data.ISBN}`);
        UpdateBookResponse response = {
            updatedBook: value
        };

        return response;
    }

    remote function RemoveBook(RemoveBookRequest value) returns RemoveBookResponse|error {
        do {

            _ = check libraryClient->execute(`DELETE FROM Books WHERE ISBN = ${value.isbn}`);
        }
        on fail var e
        {
            return error(e.message());
        }
        RemoveBookResponse response = {
            updatedBooks: []
        };

        return response;

    }
    remote function ListAvailableBooks(ListAvailableBooksRequest value) returns ListAvailableBooksResponse|error {

        // stream<Book, sql:Error?> bookStream = libraryClient->query(`SELECT * FROM Books`);
        // return from Book books in bookStream
        //     select books;

        // _ = check libraryClient->execute(`SELECT * FROM Books`);

        ListAvailableBooksResponse response = {
            availableBooks: []
        };
        return response;
    }

    remote function LocateBook(LocateBookRequest value) returns LocateBookResponse|error {
        var data = check libraryClient->execute(`SELECT Location, Status FROM Books`);
        LocateBookResponse response = {
            location: data.toJson().toBalString()
        };
        return response;
    }

    remote function BorrowBook(BorrowBookRequest value) returns BorrowBookResponse|error {
        _ = check libraryClient->execute(`INSERT INTO Borrowed_Books (UserID, ISBN)
                                            VALUES (${value.userId}, ${value.isbn})`);
        BorrowBookResponse response = {
            borrowedBook: value
        };
        return response;
    }

    remote function CreateUsers(stream<CreateUsersRequest, grpc:Error?> clientStream) returns CreateUsersResponse|error {
        CreateUsersRequest[] data = [];
        CreateUsersResponse response = {};
        check clientStream.forEach(function(CreateUsersRequest value) {
            data.push(value);
            foreach CreateUsersRequest item in data {
                foreach var d in item.users {
                    var result = libraryClient->execute(`INSERT INTO Users (UserID, Name, UserType, Contact) VALUES (${d.userId}, ${d.name}, ${d.userType}, ${d.contact})`);
                    if (result is error) {
                        io:println("Error inserting user");
                    }
                }
            }
            response = {
                users: value
            };
        });
        return response;

    }
}

