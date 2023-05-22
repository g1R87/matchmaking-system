import { Request, Response } from "express";
import BadRequestError from "../errors/bad-request";
import Img from "../models/image.model";
import User from "../models/user.model";
import { compressImage } from "../utils/image-compress";

// get profile pic
export const getPfp = async (req: Request, res: Response) => {
  const pfpString = await User.findById(res.locals.user.userID).select(
    "pfp -_id"
  );
  res.status(200).send({ data: pfpString?.pfp.data });
};

//store profile pic
export const uploadSingle = async (req: Request, res: Response) => {
  const _id = res.locals.user.userID;
  const file: any = req.file;
  if (!file) {
    throw new BadRequestError("Please chose files");
  }
  console.log(file);

  const img = await compressImage(file, `myImage-${_id}`);

  // store in database
  const updatedDocument = {
    $set: {
      url: img.filename,
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
    files.map(async (file: any) => {
      const img = await compressImage(file, `image-${userId}`);
      return img;
    })
  );

  //iteration for database
  let result = imgArray.map((src, index) => {
    //create map to store data in collection
    let imgobj = {
      filename: `image${index}-${userId}`,
      contentType: "image/jpeg",
      image: src,
      uploader: userId,
    };

    let imgUpload = new Img(imgobj);
    return imgUpload.save().then(() => {
      return { msg: `image uploaded successfully` };
    });
  });

  Promise.all(result).then((msg) => {
    res.send(msg);
  });
};
