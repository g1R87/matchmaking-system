import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import BadRequestError from "../errors/bad-request";
import UnauthenticatedError from "../errors/unauthenticated";

import NotFoundError from "../errors/not-found";
import User, { UserInput } from "../models/user.model";

interface reqbody {
  email: String;
  password: String;
  confirmPassword: String;
}

//vote user
export const voteUserUp = async (req: Request, res: Response) => {
  const id = req.query.id as string;
  const ownId = res.locals.user.userID;
  if (!id) {
    throw new BadRequestError("Please provide id");
  }
  const user: UserInput | null = await User.findById({
    _id: ownId,
  });
  if (user) {
    user.matches[id] = user.matches[id] ? user.matches[id] + 1 : 1;
    const updatedMatch = user.matches;
    const updateduser = await User.updateOne(
      { _id: ownId },
      { matches: updatedMatch }
    );
    const ohterUser: UserInput | null = await User.findById({
      _id: id,
    });
    if (ohterUser) {
      if (
        ohterUser.pending.includes(ownId) ||
        ohterUser.chatList.includes(ownId)
      ) {
        res.status(200).send(updateduser);
      } else {
        const updatedPending = ohterUser.pending.concat([ownId]);
        await User.updateOne({ _id: id }, { pending: updatedPending });
        res.status(200).send(updateduser);
      }
    }
    throw new NotFoundError("No users found");
  }
  throw new NotFoundError("No users found");
};

//vote down
export const voteUserDown = async (req: Request, res: Response) => {
  const id = req.query.id as string;
  if (!id) {
    throw new BadRequestError("Please provide id");
  }
  const user: any = await User.findById({ _id: res.locals.user.userID });
  user.matches[id] = user.matches[id] ? user.matches[id] - 1 : -1;
  const updatedMatch = user.matches;
  const updateduser = await User.updateOne(
    { _id: res.locals.user.userID },
    { matches: updatedMatch }
  );

  res.status(200).send(updateduser);
};

//fetch chat list
export const fetchChat = async (req: Request, res: Response) => {
  const _id = res.locals.user.userID;
  const user: UserInput | null = await User.findById(_id);
  if (user) {
    const chatList = user.chatList;
    const chatListUsers = await User.find({ _id: { $in: chatList } });
    res.send(chatListUsers);
  }
};

//fetch pending
export const fetchPending = async (req: Request, res: Response) => {
  const _id = res.locals.user.userID;
  const user: UserInput | null = await User.findById(_id);
  if (user) {
    const pendingList = user.pending;
    const pendingUsers = await User.find({ _id: { $in: pendingList } });
    res.send(pendingUsers);
  }
  throw new NotFoundError("Not found");
};

//accept req
export const updateChatlist = async (req: Request, res: Response) => {
  const ownId = res.locals.user.userID;
  console.log(req.body);
  const { reqId } = req.body;

  if (!reqId) {
    throw new BadRequestError("Request id required");
  }

  const ownUser: UserInput | null = await User.findById(ownId);
  const reqUser: UserInput | null = await User.findById(reqId);
  if (ownUser && reqUser) {
    const pendingList = ownUser.pending;
    const index = pendingList.indexOf(reqId);
    if (index > -1) {
      pendingList.splice(index, 1);
    }
    const updatedChatlist1 = ownUser.chatList.concat([reqId]);
    await User.updateOne(
      { _id: ownId },
      { chatList: updatedChatlist1, pending: pendingList }
    );
    const updatedChatlist2 = reqUser.chatList.concat([ownId]);
    await User.updateOne({ _id: reqId }, { chatList: updatedChatlist2 });
    res.status(200).send({ msg: "Success" });
  }
};

//reject  req
export const updateMatches = async (req: Request, res: Response) => {
  const ownId = res.locals.user.userID;
  const { reqId } = req.body;

  if (!reqId) {
    throw new BadRequestError("Request id required");
  }
  const ownUser: UserInput | null = await User.findById(ownId);
  if (ownUser) {
    const pendingList = ownUser.pending;
    const index = pendingList.indexOf(reqId);
    if (index > -1) {
      pendingList.splice(index, 1);
    }
    await User.updateOne({ _id: ownId }, { pending: pendingList });

    res.status(200).send({ msg: "Success" });
  }
};
