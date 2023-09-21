import ballerina/io;

LibraryServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    AddBookRequest addBookRequest = {book: {isbn: "9780451524956", title: "ballerina", author: "ballerina", location: "Section A", status: "Available"}};
    AddBookResponse addBookResponse = check ep->AddBook(addBookRequest);
    io:println(addBookResponse);

    UpdateBookRequest updateBookRequest = {isbn: "9780451524956", book: {isbn: "ballerina", title: "ballerina", author: "ballerina", location: "ballerina", status: "Available"}};
    UpdateBookResponse updateBookResponse = check ep->UpdateBook(updateBookRequest);
    io:println(updateBookResponse);

    RemoveBookRequest removeBookRequest = {isbn: "9780451524956"};
    RemoveBookResponse removeBookResponse = check ep->RemoveBook(removeBookRequest);
    io:println(removeBookResponse);

    ListAvailableBooksRequest listAvailableBooksRequest = {};
    ListAvailableBooksResponse listAvailableBooksResponse = check ep->ListAvailableBooks(listAvailableBooksRequest);
    io:println(listAvailableBooksResponse);

    LocateBookRequest locateBookRequest = {isbn: "ballerina"};
    LocateBookResponse locateBookResponse = check ep->LocateBook(locateBookRequest);
    io:println(locateBookResponse);

    BorrowBookRequest borrowBookRequest = {userId: 0, isbn: "9781400032716"};
    BorrowBookResponse borrowBookResponse = check ep->BorrowBook(borrowBookRequest);
    io:println(borrowBookResponse);

    CreateUsersRequest createUsersRequest = {users: [{userId: 1, name: "ballerina", userType: "Student", contact: "ballerina"}]};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendCreateUsersRequest(createUsersRequest);
    check createUsersStreamingClient->complete();
    CreateUsersResponse? createUsersResponse = check createUsersStreamingClient->receiveCreateUsersResponse();
    io:println(createUsersResponse);
}

