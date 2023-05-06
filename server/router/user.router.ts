import { Router } from "express";
import * as userController from "../controller/user.controller";
import isLoggedIn from "../middleware/authentication";
const userRouter = Router();

userRouter.post("/login", userController.login);
userRouter.post("/signup", userController.signup);
userRouter.get("/gendered-users", userController.getUsers);
userRouter.get("/all", userController.getAllUsers);
userRouter.get("/", userController.getUser);
userRouter.put("/", isLoggedIn, userController.updateUser);
userRouter.put("/match", userController.matchUser);

//! temp remove later
userRouter.get("/updateall", userController.updateall);

export default userRouter;
