import { Server } from "socket.io";
import http from "http";
import express from "express";

const app = express();

const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*",
  },
});

const userSocketMap = {};

export function getReceiverSocketId(
  userId
) {
  return userSocketMap[userId];
}

io.on("connection", (socket) => {
  console.log(
    "User Connected:",
    socket.id
  );

  const userId =
    socket.handshake.query.userId;

  if (userId) {
    userSocketMap[userId] =
      socket.id;
  }

  socket.on("disconnect", () => {
    console.log(
      "User Disconnected:",
      socket.id
    );

    delete userSocketMap[userId];
  });
});

export {
  io,
  app,
  server,
};