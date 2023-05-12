import { Router } from "express";
import * as authController from "../controller/auth.controller";
const authRouter = Router();

authRouter.post("/login", authController.login);
authRouter.get("/refresh", authController.handleRefreshToken);
authRouter.get("/logout", authController.logout);

export default authRouter;
