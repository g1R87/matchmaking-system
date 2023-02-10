import { Request, Response } from "express";
import User from "../models/user.model";

export const signup = async (req: Request, res: Response) => {
  console.log(req.body);
  const user = await User.create({ ...req.body });
  res.status(201).send(user);
};
