let chatInput = document.querySelector(".message");
let chatWindow = document.querySelector(".chat-window");
let myName = document.querySelector(".me .user-name");
let userName = prompt("Enter Your Name : ");

myName.textContent = userName;

chatInput.addEventListener("keypress", (event) => {
    if(event.key == "Enter" && chatInput.value) {
        let messageDiv = document.createElement('div');
        messageDiv.classList.add('chat');
        messageDiv.classList.add('right');
        messageDiv.textContent = chatInput.value;
        chatWindow.append(messageDiv);
        chatInput.value = "";
        socket.emit("sentMessage", messageDiv.textContent, userName);
    }
})





const socket = io();
const imageUpload = document.getElementById('imageUpload');
const micButton = document.getElementById('micButton');

// Handle image upload
imageUpload.addEventListener('change', () => {
  const file = imageUpload.files[0];
  const reader = new FileReader();

  reader.onload = (event) => {
    const imgData = event.target.result;
    socket.emit('send-image', imgData);
  };

  reader.readAsDataURL(file);
});

// Handle microphone usage
micButton.addEventListener('click', () => {
  // Implement microphone functionality here
});

const recognition = new webkitSpeechRecognition();
recognition.continuous = true;
recognition.interimResults = true;

micButton.addEventListener('click', () => {
  recognition.start();
});

recognition.addEventListener('result', (event) => {
  const transcript = event.results[0][0].transcript;
  socket.emit('send-message', transcript);
});