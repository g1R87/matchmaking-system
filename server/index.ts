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
import Msg, { MsgInput } from "./models/message.model";
import User from "./models/user.model";
import appRouter from "./router";
import { convertDateList } from "./utils/date-convert";
import { findId } from "./utils/find-id";
import {
  deleteClient,
  deleteInterest,
  getIdDeletePair,
} from "./utils/socket-functions";
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
app.use(notFound);
app.use(errorHandlerMiddleware);

var clients: any = {};
var pair: any = {};
var interest: any = {};
var key: any = {};

//*=============================socket section========================================================
//socket io integration
io.on("connection", (socket) => {
  console.log("a user is connected", socket.id);
  socket.on("disconnect", () => {
    console.log("disconnected", socket.id);
    deleteClient(socket.id, clients);
    deleteInterest(socket.id, interest);
    const tid = getIdDeletePair(socket.id, pair);
    if (clients[tid]) {
      clients[tid].emit("offline", { tid });
    }
  });

  //normal chat
  socket.on("message", (msg) => {
    console.log(msg);
    const targetId = msg.targetId;

    // const message = new Msg({
    //   from_userId: msg.sourceId,
    //   to_userId: msg.targetId,
    //   message: msg.message,
    // });
    // message.save().then(() => {
    //   if (clients[msg.targetId]) {
    //     clients[msg.targetId].emit("message", msg);
    //   }
    // });
    if (clients[msg.targetId]) {
      clients[msg.targetId].emit("message", msg);
    }
    socket.broadcast.emit("message-received", msg);
  });

  //
  socket.on("signin", async (data) => {
    console.log(data);
    const sid = data.sourceId;
    const tid = data.targetId;
    const e = data.pubkey1;
    const n = data.pubkey2;
    clients[sid] = socket;
    pair[socket.id] = { sid, tid };
    console.log(pair);
    key[sid] = [e, n];
    const oldmsg: Array<MsgInput> = await Msg.find({
      from_userId: { $in: [sid, tid] },
      to_userId: { $in: [sid, tid] },
    });

    const historyMsg = convertDateList(oldmsg);
    console.log(historyMsg);

    // clients[sid].emit("key", { e, n });

    clients[sid].emit("history", historyMsg);

    //todo: add "key" event here

    console.log("The clients: ", Object.keys(clients));
  });

  socket.on("getkey", (data) => {
    console.log("getkey fired");
    const sid = data.sourceId;
    const tid = data.targetId;
    if (clients[sid] && clients[tid]) {
      clients[sid].emit("key", { e: key[tid][0], n: key[tid][1] });
      clients[tid].emit("key", { e: key[sid][0], n: key[sid][1] });
    }
  });

  //random chat
  socket.on("login", (data) => {
    const sid = data.sourceId;
    const iList = data.list;
    clients[sid] = socket;
    interest[sid] = { id: socket.id, iList };

    // interest[sid] = iList;
    console.log("interest list updated: ", Object.keys(interest));
    console.log("the clients are ", Object.keys(clients));
  });

  socket.on("search", async (data) => {
    console.log(data);
    const sid = data.sourceId;
    const iList = data.list;
    const match = findId(sid, interest);
    if (match.id == "") {
      clients[sid].emit("notfound", { msg: "Not Found" });
    } else {
      pair[socket.id] = { sid, tid: match.id };
      console.log(pair);
      const user = await User.findById(match.id);
      clients[sid].emit("found", user);
      const uesr2 = await User.findById(sid);
      if (clients[match.id]) {
        clients[match.id].emit("found", uesr2);
      }
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
