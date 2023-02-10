import "dotenv/config";
import express from "express";
import "express-async-errors";
import mongoose from "mongoose";
import connectDB from "./db/connect";
import errorHandlerMiddleware from "./middleware/error-handler";
import notFound from "./middleware/not-found";
import appRouter from "./router";

const app = express();
app.use(express.json());
app.use("/", appRouter);

app.use(notFound);
app.use(errorHandlerMiddleware);

const PORT = process.env.port || 5200;

const start = async () => {
  try {
    mongoose.set("strictQuery", false);
    await connectDB(process.env.MONGO_URI as string);
    app.listen(PORT, () => console.log(`Running on port ${PORT}`));
  } catch (error) {
    console.log(error);
  }
};

start();
