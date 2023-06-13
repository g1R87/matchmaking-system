import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import BadRequestError from "../errors/bad-request";
import UnauthenticatedError from "../errors/unauthenticated";
import Msg, { MsgInput } from "../models/message.model";

import { promises } from "dns";
import NotFoundError from "../errors/not-found";
import User, { UserInput } from "../models/user.model";
import { convertDate } from "../utils/date-convert";

interface reqbody {
  email: String;
  password: String;
  confirmPassword: String;
}

/*
  Match score
    like = 1
    dislike = no fixed score, starts decreasing by 1
    blacklist = < -3
    chatlist = 99 
*/

//vote user
export const voteUserUp = async (req: Request, res: Response) => {
  const id = req.query.id as string;
  const ownId = res.locals.user.userID;
  if (!id) {
    throw new BadRequestError("Please provide id");
  }

  if (id == ownId) {
    throw new BadRequestError("Cannot vote yourself");
  }

  const user: UserInput | null = await User.findById({
    _id: ownId,
  });
  if (user) {
    user.matches[id] = 1;
    // user.matches[id] = user.matches[id] ? user.matches[id] + 1 : 1;
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
  const ownId = res.locals.user.userID;

  if (!id) {
    throw new BadRequestError("Please provide id");
  }

  if (ownId == id) {
    throw new BadRequestError("Cannot vote yourself");
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
    const chatUsers = await User.find({ _id: { $in: chatList } });
    const getLatestMessage = await Promise.all(
      chatUsers.map(async (e: UserInput) => {
        const oldmsg: MsgInput | null = await Msg.findOne({
          from_userId: { $in: [_id, e._id] },
          to_userId: { $in: [_id, e._id] },
        })
          .sort({ _id: -1 })
          .limit(1);

        if (oldmsg) {
          const latestMsg = convertDate(oldmsg);

          return {
            _id: e.id,
            about: e.about,
            first_name: e.first_name,
            gender_identity: e.gender_identity,
            gender_interest: e.gender_interest,
            pfp: {
              data: e.pfp.data,
            },
            url2: e.url2,
            url3: e.url3,
            dob_day: e.dob_day,
            dob_month: e.dob_month,
            dob_year: e.dob_year,
            message: latestMsg.message,
            createdAt: latestMsg.createdAt,
          };
        } else {
          return e;
        }
      })
    );
    res.send(getLatestMessage);
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
    //update matches(accept req => score = 99)
    ownUser.matches[reqId] = 99;
    reqUser.matches[ownId] = 99;
    const updatedMatches1 = ownUser.matches;
    const updatedMatches2 = reqUser.matches;

    //remove from pending list
    const pendingList = ownUser.pending;
    const index = pendingList.indexOf(reqId);
    if (index > -1) {
      pendingList.splice(index, 1);
    }

    //add to chatlist
    const updatedChatlist1 = ownUser.chatList.concat([reqId]);
    const updatedChatlist2 = reqUser.chatList.concat([ownId]);

    //update action
    await User.updateOne(
      { _id: ownId },
      {
        chatList: updatedChatlist1,
        pending: pendingList,
        matches: updatedMatches1,
      }
    );
    await User.updateOne(
      { _id: reqId },
      { chatList: updatedChatlist2, matches: updatedMatches2 }
    );
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

//delete chat
export const delChatlist = async (req: Request, res: Response) => {
  const ownId = res.locals.user.userID;
  console.log(req.body);
  const { reqId } = req.body;

  if (!reqId) {
    throw new BadRequestError("Request id required");
  }

  const ownUser: UserInput | null = await User.findById(ownId);
  const reqUser: UserInput | null = await User.findById(reqId);
  if (ownUser && reqUser) {
    //update matches score
    ownUser.matches[reqId] = 0;
    reqUser.matches[ownId] = 1;
    const updatedMatches1 = ownUser.matches;
    const updatedMatches2 = reqUser.matches;

    const ownChatList = ownUser.chatList;
    const reqIndex = ownChatList.indexOf(reqId);
    if (reqIndex > -1) {
      ownChatList.splice(reqIndex, 1);
    }
    await User.updateOne(
      { _id: ownId },
      { chatList: ownChatList, matches: updatedMatches1 }
    );
    const reqChatList = reqUser.chatList;
    const ownIndex = reqChatList.indexOf(ownId);
    if (ownIndex > -1) {
      reqChatList.splice(ownIndex, 1);
    }
    await User.updateOne(
      { _id: reqId },
      { chatList: reqChatList, matches: updatedMatches2 }
    );
    res.status(200).send({ msg: "Success" });
  }
};
