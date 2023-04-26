import { Router } from "express";
import * as msgController from "../controller/message.controller";
const msgRouter = Router();

msgRouter.get("/", msgController.getMsg);
msgRouter.get("/all", msgController.test);
msgRouter.post("/", msgController.addMsg);
export default msgRouter;
