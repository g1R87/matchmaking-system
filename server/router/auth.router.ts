import { Router } from "express";
import * as authController from "../controller/auth.controller";
const authRouter = Router();

authRouter.post("/login", authController.login);
authRouter.post("/refresh", authController.handleRefreshToken);
authRouter.post("/logout", authController.logout);

export default authRouter;
