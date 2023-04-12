import { Request, Response } from "express";
import User from "../models/user.model";

export const signup = async (req: Request, res: Response) => {
  console.log(req.body);

  const user = await User.create({ ...req.body });
  const token = user.createJWT();
  res.status(201).send({ user, token });
};

export const getUser = async (req: Request, res: Response) => {
  const users = await User.find();
  res.status(200).send(users);
};
