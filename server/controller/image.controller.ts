import { Request, Response } from "express";
import fs from "fs";
import { type } from "os";
import BadRequestError from "../errors/bad-request";
import Img from "../models/image.model";
import User from "../models/user.model";

interface FileWithPath extends File {
  path: string;
}

export const getPfp = async (req: Request, res: Response) => {
  const data = await Img.find({});
};

export const uploadSingle = async (req: Request, res: Response) => {
  const file: any = req.file;
  console.log(file);

  if (!file) {
    throw new BadRequestError("Please chose files");
  }
  const img = fs.readFileSync(file.path, "base64");

  const updatedDocument = {
    $set: {
      pfp: {
        data: img,
        contentType: file.mimetype,
      },
    },
  };

  const updatedUser = await User.updateOne(
    { _id: res.locals.user.userID },
    updatedDocument
  );

  res.status(200).send(updatedUser);
};

export const uploadMulti = async (req: Request, res: Response) => {
  console.log("multi");
  const files = req.files;
  console.log(files);

  if (!files) {
    throw new BadRequestError("Please chose files");
  }
  res.json(files);
};
