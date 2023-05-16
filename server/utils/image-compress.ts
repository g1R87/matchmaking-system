import fs from "fs";
import path from "path";
import sharp from "sharp";

type FileType = {
  filedname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  destination: string;
  filename: string;
  path: string;
  size: number;
};

export const compressImage = async (file: FileType) => {
  //   const filename = `${file.filename.split(".")[0]}.jpeg`;
  await sharp(file.path)
    .resize(200, 200)
    .jpeg({ quality: 90, force: true, mozjpeg: true })
    .toFile(path.resolve(file.destination, "resized", file.filename));
  const resizedPath = path.join("uploads", "resized", file.filename);
  return fs.readFileSync(resizedPath, "base64");
};