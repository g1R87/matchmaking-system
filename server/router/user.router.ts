import { Router } from "express";
import * as userController from "../controller/user.controller";
const userRouter = Router();

userRouter.post("/signup", userController.signup);
userRouter.get("/users", userController.getUser);

export default userRouter;
