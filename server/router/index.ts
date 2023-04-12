import { Router } from "express";
import msgRouter from "./message.router";
import userRouter from "./user.router";
const appRouter = Router();

appRouter.use("/msg", msgRouter);
// appRouter.use("/", (_req, res) => res.send("testing"));
appRouter.use("/user", userRouter);

export default appRouter;
