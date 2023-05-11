import { Router } from "express";
import * as userController from "../controller/user.controller";
import isLoggedIn from "../middleware/authentication";
const userRouter = Router();

//auth
userRouter.post("/login", userController.login);
userRouter.post("/signup", userController.signup);
//operations
userRouter.get("/gendered-users", userController.getUsers);
userRouter.get("/all", userController.getAllUsers);
userRouter.get("/", userController.getUser);
userRouter.put("/", isLoggedIn, userController.updateUser);
userRouter.put("/match", userController.matchUser);
//vote
userRouter.post("/voteup", isLoggedIn, userController.voteUserUp);
userRouter.post("/votedown", isLoggedIn, userController.voteUserDown);
//fetching algorithm endpoint
userRouter.get("/fetchuser", isLoggedIn, userController.fetchUser);

//! temp remove later
userRouter.get("/updateall", userController.updateall);

export default userRouter;
