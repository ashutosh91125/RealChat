<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Spring Boot Chat</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .chat-container {
            max-width: 700px;
            margin: 0 auto;
        }
        .chat-messages {
            height: 400px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .message {
            margin-bottom: 10px;
            padding: 8px;
            border-radius: 5px;
        }
        .message.join, .message.leave {
            background-color: #f8f9fa;
            color: #6c757d;
            text-align: center;
        }
        .message.chat {
            background-color: #e9ecef;
        }
        .timestamp {
            font-size: 0.8em;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="chat-container">
            <h2 class="text-center mb-4">Spring Boot Chat Application</h2>
            
            <div id="username-page">
                <div class="form-group">
                    <input type="text" id="name" class="form-control" placeholder="Enter your name">
                    <button type="button" class="btn btn-primary mt-3" onclick="connect()">Join Chat</button>
                </div>
            </div>

            <div id="chat-page" class="d-none">
                <div class="chat-messages" id="messageArea">
                    <c:forEach items="${messages}" var="msg">
                        <div class="message ${msg.type.toString().toLowerCase()}">
                            <c:if test="${msg.type == 'CHAT'}">
                                <strong>${msg.sender}:</strong> ${msg.content}
                            </c:if>
                            <c:if test="${msg.type == 'JOIN'}">
                                ${msg.sender} joined the chat
                            </c:if>
                            <c:if test="${msg.type == 'LEAVE'}">
                                ${msg.sender} left the chat
                            </c:if>
                            <div class="timestamp">${msg.timestamp}</div>
                        </div>
                    </c:forEach>
                </div>
                
                <form id="messageForm" class="form-inline">
                    <div class="input-group">
                        <input type="text" id="message" class="form-control" placeholder="Type a message...">
                        <button type="submit" class="btn btn-primary">Send</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        let stompClient = null;
        let username = null;

        function connect() {
            username = document.getElementById('name').value.trim();
            if (username) {
                document.getElementById('username-page').classList.add('d-none');
                document.getElementById('chat-page').classList.remove('d-none');

                const socket = new SockJS('/ws');
                stompClient = Stomp.over(socket);

                stompClient.connect({}, onConnected, onError);
            }
        }

        function onConnected() {
            // Subscribe to public topic
            stompClient.subscribe('/topic/public', onMessageReceived);

            // Send join message
            stompClient.send("/app/chat.addUser",
                {},
                JSON.stringify({sender: username, type: 'JOIN'})
            );
        }

        function onError(error) {
            console.log('Could not connect to WebSocket server. Please refresh this page to try again!');
        }

        function sendMessage(event) {
            const messageInput = document.getElementById('message');
            const messageContent = messageInput.value.trim();
            
            if (messageContent && stompClient) {
                const chatMessage = {
                    sender: username,
                    content: messageContent,
                    type: 'CHAT'
                };
                
                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(chatMessage));
                messageInput.value = '';
            }
            event.preventDefault();
        }

        function onMessageReceived(payload) {
            const message = JSON.parse(payload.body);
            const messageArea = document.getElementById('messageArea');
            const messageElement = document.createElement('div');
            
            messageElement.classList.add('message');
            messageElement.classList.add(message.type.toLowerCase());

            let content = '';
            if (message.type === 'JOIN') {
                content = message.sender + ' joined the chat';
            } else if (message.type === 'LEAVE') {
                content = message.sender + ' left the chat';
            } else {
                content = '<strong>' + message.sender + ':</strong> ' + message.content;
            }

            messageElement.innerHTML = content + '<div class="timestamp">' + new Date().toLocaleString() + '</div>';
            messageArea.appendChild(messageElement);
            messageArea.scrollTop = messageArea.scrollHeight;
        }

        document.getElementById('messageForm').addEventListener('submit', sendMessage, true);
    </script>
</body>
</html>
