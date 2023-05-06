import { Router } from "express";
import isLoggedIn from "../middleware/authentication";
import imgRouter from "./image.router";
import msgRouter from "./message.router";
import userRouter from "./user.router";
const appRouter = Router();

appRouter.use("/msg", isLoggedIn, msgRouter);
// appRouter.use("/", (_req, res) => res.send("testing"));
appRouter.use("/user", userRouter);
appRouter.use("/image", isLoggedIn, imgRouter);

export default appRouter;
