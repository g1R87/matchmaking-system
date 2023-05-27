import { Request, Response } from "express";
import BadRequestError from "../errors/bad-request";
import User from "../models/user.model";
import { compressImage, processImage } from "../utils/image-compress";

// get profile pic
export const getPfp = async (req: Request, res: Response) => {
  const pfpString = await User.findById(res.locals.user.userID).select(
    "pfp -_id"
  );
  res.status(200).send({ data: pfpString?.pfp.data });
};

//store profile pic
export const uploadPfp = async (req: Request, res: Response) => {
  const _id = res.locals.user.userID;
  const file: any = req.file;
  if (!file) {
    throw new BadRequestError("Please chose files");
  }
  console.log(file.length);

  const img = await compressImage(file, `myImage-${_id}.jpg`);
  await processImage(file, `myImage-${_id}.jpg`);

  // store in database
  const updatedDocument = {
    $set: {
      url1: img.filename,
      pfp: {
        data: img.filedata,
        contentType: file.mimetype,
      },
    },
  };

  const updatedUser = await User.updateOne(
    { _id: res.locals.user.userID },
    updatedDocument
  );

  res.status(200).send(updatedUser);
  // res.send(img);
};

//upload single image
export const uploadSingle = async (req: Request, res: Response) => {
  const _id = res.locals.user.userID;
  const index = +req.params.in;
  // const { index } = req.body;
  if (!index || (index != 1 && index != 0)) {
    throw new BadRequestError("Please provide valid index 0/1");
  }

  const file: any = req.file;
  if (!file) {
    throw new BadRequestError("Please chose files");
  }

  if (index == 0) {
    const link = await processImage(file, `image0-${_id}.jpg`);

    // store in database
    const updatedDocument = {
      $set: {
        url2: link,
      },
    };

    const updatedUser = await User.updateOne(
      { _id: res.locals.user.userID },
      updatedDocument
    );

    res.status(200).send(updatedUser);
  }
  const link = await processImage(file, `image1-${_id}.jpg`);

  // store in database
  const updatedDocument = {
    $set: {
      url3: link,
    },
  };

  const updatedUser = await User.updateOne(
    { _id: res.locals.user.userID },
    updatedDocument
  );

  res.status(200).send(updatedUser);

  // res.send(img);
};

//upload multiple photos
export const uploadMulti = async (req: Request, res: Response) => {
  const files: any = req.files;
  const userId = res.locals.user.userID;

  if (!files) {
    throw new BadRequestError("Please chose file");
  }
  console.log(files.length);
  //iterate over images and compress
  let imgArray = await Promise.all(
    files.map(async (file: any, i: number) => {
      const img = await processImage(file, `image${i}-${userId}.jpg`);
      return img;
    })
  );

  const updatedDocument = {
    $set: {
      url2: imgArray[0],
      url3: imgArray[1],
    },
  };

  const updatedUser = await User.updateOne(
    { _id: res.locals.user.userID },
    updatedDocument
  );

  res.status(200).send(updatedUser);
};
