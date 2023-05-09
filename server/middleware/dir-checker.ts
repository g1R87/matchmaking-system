import { NextFunction, Request, Response } from "express";
import fs from "fs";

export const dirChecker = (
  _req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    fs.access("./uploads", (error) => {
      if (error) {
        fs.mkdir("./uploads", (err) => {
          if (err) return console.error(err);
          fs.access("./uploads/resized", (error) => {
            if (error) {
              fs.mkdir("./uploads/resized", (err) => {
                if (err) return console.error(err);
                next();
              });
            }
          });
        });
      } else {
        next();
      }
    });
  } catch (error: any) {
    throw new Error(error.message);
  }
};
