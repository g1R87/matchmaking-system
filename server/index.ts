import cookieParser from "cookie-parser";
import cors from "cors";
import "dotenv/config";
import express from "express";
import "express-async-errors";
import http from "http";
import mongoose from "mongoose";
import { Server } from "socket.io";
import connectDB from "./db/connect";
import errorHandlerMiddleware from "./middleware/error-handler";
import notFound from "./middleware/not-found";
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
app.use("/", appRouter);
const host = "192.168.1.109";
// app.use("/", (req, res) => {
//   res.send("helo");
// });
app.use(notFound);
app.use(errorHandlerMiddleware);

//socket io integration
io.on("connection", (socket) => {
  console.log("a user is connected", socket.id);
  socket.on("disconnect", () => {
    console.log("disconnected", socket.id);
  });

  socket.on("message", (data) => {
    console.log(data);
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
