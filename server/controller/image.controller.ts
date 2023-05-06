import { Request, Response } from "express";
import fs from "fs";
import { type } from "os";
import path from "path";
import sharp from "sharp";
import BadRequestError from "../errors/bad-request";
import Img from "../models/image.model";
import User from "../models/user.model";

interface FileWithPath extends File {
  path: string;
}

//get profile pic
export const getPfp = async (req: Request, res: Response) => {
  const data = await User.findById(res.locals.user.userID).select("pfp -_id");
  res.status(200).send(data);
};

//store profile pic
export const uploadSingle = async (req: Request, res: Response) => {
  //check dir
  fs.access("./uploads", (error) => {
    if (error) {
      fs.mkdirSync("./uploads");
    }
  });
  fs.access("./uploads/resized", (error) => {
    if (error) {
      fs.mkdirSync("./uploads/resized");
    }
  });

  //read req body
  const file: any = req.file;
  if (!file) {
    throw new BadRequestError("Please chose files");
  }
  console.log(file);

  //compression and conversion to base64
  await sharp(file.path)
    .resize(200, 200)
    .jpeg({ quality: 90 })
    .toFile(path.resolve(file.destination, "resized", file.filename));
  const resizedPath = path.join("uploads", "resized", file.filename);
  const img = fs.readFileSync(resizedPath, "base64");

  //store in database
  const updatedDocument = {
    $set: {
      pfp: {
        data: img,
        contentType: "image/jpeg",
      },
    },
  };

  const updatedUser = await User.updateOne(
    { _id: res.locals.user.userID },
    updatedDocument
  );

  res.status(200).send(updatedUser);
};

//upload multiple photos
export const uploadMulti = async (req: Request, res: Response) => {
  console.log("multi");
  fs.access("./uploads", (error) => {
    if (error) {
      fs.mkdirSync("./uploads");
    }
  });
  fs.access("./uploads/resized", (error) => {
    if (error) {
      fs.mkdirSync("./uploads/resized");
    }
  });

  const file: any = req.file;
  if (!file) {
    throw new BadRequestError("Please chose file");
  }
  console.log(file);

  await sharp(file.path)
    .resize(200, 200)
    .jpeg({ quality: 90 })
    .toFile(path.resolve(file.destination, "resized", file.filename));
  const resizedPath = path.join("uploads", "resized", file.filename);
  console.log(file.path);
  console.log(path.join(__dirname, "uploads", "resized", file.filename));
  // fs.unlinkSync(file.path);
  const img = fs.readFileSync(file.path, "base64");

  if (!file) {
    throw new BadRequestError("Please chose file");
  }
  res.json(img);
};
