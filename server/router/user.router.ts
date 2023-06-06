import { Router } from "express";
import * as filterController from "../controller/filter.controller";
import * as matchController from "../controller/match.controller";
import * as userController from "../controller/user.controller";
import isLoggedIn from "../middleware/authentication";
const userRouter = Router();

//*User operation endpoints
//create
userRouter.post("/signup", userController.signup);
//operations
userRouter.get("/gendered-users", userController.getUsers);
userRouter.get("/all", userController.getAllUsers);
userRouter.get("/", userController.getUser);
userRouter.put("/", isLoggedIn, userController.updateUser);
userRouter.put("/match", userController.matchUser);

//*Algorithm endpoints
//fetching algorithm endpoint
userRouter.get("/fetchuser", isLoggedIn, filterController.fetchUser);
userRouter.get("/search", isLoggedIn, filterController.searchUser);

//*Match endpoints
//vote
userRouter.post("/voteup", isLoggedIn, matchController.voteUserUp);
userRouter.post("/votedown", isLoggedIn, matchController.voteUserDown);
//fetching chat endpoint
userRouter.get("/fetchchat", isLoggedIn, matchController.fetchChat);
//fetching notification/pending
userRouter.get("/fetchpending", isLoggedIn, matchController.fetchPending);
//accept request
userRouter.post("/acceptreq", isLoggedIn, matchController.updateChatlist);
//reject request
userRouter.post("/rejectreq", isLoggedIn, matchController.updateMatches);
//delete chat
userRouter.delete("/chat", isLoggedIn, matchController.delChatlist);

//! temp remove later
userRouter.get("/updateall", userController.updateall);

export default userRouter;
