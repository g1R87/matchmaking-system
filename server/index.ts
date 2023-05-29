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
import User from "./models/user.model";
import appRouter from "./router";
import { findId } from "./utils/find-id";
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

var clients: any = {};
var interest: any = {};

//*=============================socket section========================================================
//socket io integration
io.on("connection", (socket) => {
  console.log("a user is connected", socket.id);
  socket.on("disconnect", () => {
    console.log("disconnected", socket.id);
  });

  //normal chat
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
    const sid = data.sourceId;
    const tid = data.targetId;
    clients[sid] = socket;
    const oldmsg = await Msg.find({
      from_userId: { $in: [sid, tid] },
      to_userId: { $in: [sid, tid] },
    });
    clients[sid].emit("history", oldmsg);

    console.log("the list are ", Object.keys(clients));
  });

  //random chat
  socket.on("login", (data) => {
    const sid = data.sourceId;
    const iList = data.list;
    clients[sid] = socket;
    interest[sid] = iList;
    console.log("interest list updated: ", interest);
    console.log("the list are ", Object.keys(clients));
  });

  socket.on("search", async (data) => {
    console.log(data);
    const sid = data.sourceId;
    const iList = data.list;
    const match = findId(sid, interest);
    if (match.id == "") {
      clients[sid].emit("notfound", { msg: "Not Found" });
    } else {
      const user = await User.findById(match.id);
      clients[sid].emit("found", user);
    }
  });

  socket.on("chat", (msg) => {
    console.log(msg);

    if (clients[msg.targetId]) {
      clients[msg.targetId].emit("chat", msg);
    }
    socket.broadcast.emit("message-received", msg);
  });
});
//*==================socket section======================================================================

app.use(notFound);
app.use(errorHandlerMiddleware);
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
