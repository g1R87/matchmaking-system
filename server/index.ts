import cookieParser from "cookie-parser";
import cors from "cors";
import { Socket } from "dgram";
import "dotenv/config";
import express from "express";
import "express-async-errors";
import http from "http";
import mongoose from "mongoose";
import { join } from "path";
import { Server } from "socket.io";
import connectDB from "./db/connect";
import errorHandlerMiddleware from "./middleware/error-handler";
import notFound from "./middleware/not-found";
import Msg from "./models/message.model";
import appRouter from "./router";
const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*",
  },
});
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static("public"));
app.use("/image", express.static(join(__dirname, "Uploads", "Resized")));
app.use("/", appRouter);
const host = "192.168.1.109";

app.use(notFound);
app.use(errorHandlerMiddleware);

var clients: any = {};

//socket io integration
io.on("connection", (socket) => {
  console.log("a user is connected", socket.id);
  socket.on("disconnect", () => {
    console.log("disconnected", socket.id);
  });

  socket.on("message", (msg) => {
    console.log(msg);
    const targetId = msg.targetId;

    const message = new Msg({
      from_userId: msg.sourceId,
      to_userId: msg.targetId,
      message: msg.message,
    });
    message.save().then(() => {
      if (clients[msg.targetId]) {
        clients[msg.targetId].emit("message", msg);
      }
    });
    socket.broadcast.emit("message-received", msg);
  });

  socket.on("signin", async (data) => {
    console.log(data);
    clients[data.sourceId] = socket;
    const oldmsg = await Msg.find({
      from_userId: data.sourceId,
      to_userId: data.targetId,
    });
    clients[data.sourceId].emit("history", oldmsg);
    if (clients[data.targetId]) {
      clients[data.targetId].emit("history", oldmsg);
    }

    console.log("the list are ", Object.keys(clients));
  });
});

const PORT = process.env.port || 5200;

const start = async () => {
  try {
    mongoose.set("strictQuery", false);
    await connectDB(process.env.MONGO_URI as string);
    server.listen(PORT as number, "0.0.0.0", () =>
      console.log(`Running on port ${PORT}`)
    );
  } catch (error) {
    console.log(error);
  }
};

start();
