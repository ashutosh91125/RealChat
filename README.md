# Spring Boot Real-Time Chat Application

A real-time chat application built using Spring Boot, WebSocket, and JSP with a modern Bootstrap UI.

## Features

- Real-time messaging using WebSocket
- Persistent chat history using H2 database
- User join/leave notifications
- Modern responsive UI using Bootstrap
- Message timestamps
- H2 Console for database management

## Technologies Used

- **Backend**
  - Spring Boot 3.1.0
  - Spring WebSocket
  - Spring Data JPA
  - H2 Database
  - Lombok
  - JSP (JavaServer Pages)

- **Frontend**
  - Bootstrap 5.1.3
  - SockJS
  - STOMP.js
  - HTML5/CSS3
  - JavaScript

## Project Structure

```
src/
├── main/
    ├── java/
    │   └── com/example/chat/
    │       ├── config/
    │       │   └── WebSocketConfig.java
    │       ├── controller/
    │       │   ├── ChatController.java
    │       │   └── WebController.java
    │       ├── model/
    │       │   └── ChatMessage.java
    │       ├── repository/
    │       │   └── ChatMessageRepository.java
    │       └── ChatApplication.java
    ├── resources/
    │   └── application.properties
    └── webapp/
        └── WEB-INF/
            └── jsp/
                └── chat.jsp
```

## Setup & Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```bash
   cd spring-boot-chat
   ```

3. Run the application using Maven:
   ```bash
   mvn spring-boot:run
   ```

4. Access the application:
   - Chat Application: http://localhost:8080
   - H2 Database Console: http://localhost:8080/h2-console

## Database Configuration

The application uses H2 database with the following configuration:
- URL: jdbc:h2:file:./chatdb
- Username: sa
- Password: (empty)

## WebSocket Endpoints

- `/ws` - WebSocket endpoint
- `/topic/public` - Public topic for messages
- `/app/chat.sendMessage` - Send message endpoint
- `/app/chat.addUser` - User join endpoint

## Message Types

- `CHAT` - Regular chat messages
- `JOIN` - User join notifications
- `LEAVE` - User leave notifications

## Features Explanation

1. **Real-time Communication**
   - Uses STOMP (Simple Text Oriented Messaging Protocol) over WebSocket
   - Implements publish-subscribe pattern for message broadcasting

2. **Persistent Storage**
   - Messages are stored in H2 database
   - Stores message content, sender, timestamp, and message type
   - Allows message history viewing

3. **User Experience**
   - Clean, responsive UI using Bootstrap
   - Real-time message updates
   - Join/Leave notifications
   - Message timestamps
   - Mobile-friendly design

## Contributing

Feel free to fork the project and submit pull requests.

## License

This project is open source and available under the [MIT License](LICENSE).
