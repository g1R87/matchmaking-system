import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import BadRequestError from "../errors/bad-request";
import UnauthenticatedError from "../errors/unauthenticated";

import User from "../models/user.model";

export const login = async (req: Request, res: Response) => {
  console.log(req.body);
  const { email, password } = req.body;

  if (!email || !password) {
    throw new BadRequestError("Email/Password is required");
  }

  const user = await User.findOne({ email });
  if (!user) {
    throw new UnauthenticatedError("Invalid credentials / User doesnt exist");
  }

  const isPasswordCorrect = await user.checkPassword(password);
  if (!isPasswordCorrect) {
    throw new UnauthenticatedError("invalid credentials");
  }

  const token = user.createJWT();
  res.status(StatusCodes.OK).json({ user, token });
};

export const signup = async (req: Request, res: Response) => {
  console.log(req.body);

  const user = await User.create({ ...req.body });
  const token = user.createJWT();
  res.status(StatusCodes.CREATED).send({ user, token });
};

//temporary
export const getUser = async (req: Request, res: Response) => {
  const users = await User.find();
  res.status(StatusCodes.OK).send(users);
};
