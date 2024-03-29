import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import UnauthenticatedError from "../errors/unauthenticated";

interface jwtPayload {
  userId: string;
  name: string;
}

const isLoggedIn = async (req: Request, res: Response, next: NextFunction) => {
  //checking header
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    throw new UnauthenticatedError("authentication invalid");
  }

  const token = authHeader.split(" ")[1];
  try {
    const payload = jwt.verify(
      token,
      process.env.JWT_SECRET as string
    ) as jwtPayload;
    res.locals.user = payload;
    next();
  } catch (error) {
    throw new UnauthenticatedError("Authentication Invalid");
  }
};

export default isLoggedIn;
