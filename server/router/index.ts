import { Router } from "express";
import msgRouter from "./message.router";
import userRouter from "./user.router";
const appRouter = Router();

appRouter.use("/user", userRouter);
appRouter.use("/msg", msgRouter);

export default appRouter;
