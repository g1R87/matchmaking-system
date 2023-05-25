import { Router } from "express";
import * as imgController from "../controller/image.controller";
import { upload } from "../middleware/multer";
const imgRouter = Router();

imgRouter.get("/pfp", imgController.getPfp);
imgRouter.post("/pfp", upload.single("myImage"), imgController.uploadPfp);
imgRouter.post(
  "/uploadall",
  upload.array("image", 2),
  imgController.uploadMulti
);
imgRouter.post(
  "/upload/:in",
  upload.single("image"),
  imgController.uploadSingle
);

// imgRouter.post("/upload", upload.array("image", 3), imgController.uploadMulti);
export default imgRouter;
