import { Router } from "express";
import * as imgController from "../controller/image.controller";
import { upload } from "../middleware/multer";
const imgRouter = Router();

imgRouter.get("/pfp", imgController.getPfp);
imgRouter.post("/pfp", upload.single("myImage"), imgController.uploadSingle);

imgRouter.post("/upload", upload.array("image", 3), imgController.uploadMulti);
export default imgRouter;
