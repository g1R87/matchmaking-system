import { NextFunction, Request, Response } from "express";

const errorHandlerMiddleware = (
  err: any,
  _req: Request,
  res: Response,
  _next: NextFunction
) => {
  console.log("middleware: ", err);
  let customError = {
    statusCode: err.statusCode || 500,
    msg: err.message || "Something went wrong. Please try again later.",
  };

  //validation error
  if (err.name === "ValidationError") {
    customError.msg = Object.values(err.errors)
      .map((item: any) => item.message)
      .join(",");
    customError.statusCode = 400;
  }

  return res.status(customError.statusCode).json({ msg: customError.msg });
  //   return res.status(500).json({ err });
};

export default errorHandlerMiddleware;
