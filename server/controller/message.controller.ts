import { Request, Response } from "express";
import Messages from "../models/message.model";

export const test = async (req: Request, res: Response) => {
  const msg = await Messages.find();
  console.log("message controller");
  res.send(msg);
};

export const getMsg = async (req: Request, res: Response) => {
  const { fromUserId, toUserId } = req.query;
  console.log(req.query);
  const query = {
    from_userId: fromUserId,
    to_userId: toUserId,
  };
  const msg = await Messages.find(query);
  res.send(msg);
};

export const addMsg = async (req: Request, res: Response) => {
  const message = req.body;
  console.log(res.locals.user);
  const query = { from_userId: res.locals.user.userID, ...message };
  console.log(query);
  const msg = await Messages.create(query);
  res.send(msg);
};
