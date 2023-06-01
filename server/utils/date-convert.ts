import { MsgInput } from "../models/message.model";

export const convertDateList = (oldmsg: Array<MsgInput>) => {
  return oldmsg.map((e: MsgInput) => {
    const date = e.createdAt;
    const parsedDate = new Date(date);
    parsedDate.setHours(parsedDate.getHours() + 5);
    parsedDate.setMinutes(parsedDate.getMinutes() + 45);
    return {
      from_userId: e.from_userId,
      to_userId: e.to_userId,
      message: e.message,
      createdAt: parsedDate,
    };
  });
};

export const convertDate = (oldmsg: MsgInput) => {
  const date = oldmsg.createdAt;
  const parsedDate = new Date(date);
  parsedDate.setHours(parsedDate.getHours() + 5);
  parsedDate.setMinutes(parsedDate.getMinutes() + 45);
  return {
    from_userId: oldmsg.from_userId,
    to_userId: oldmsg.to_userId,
    message: oldmsg.message,
    createdAt: parsedDate,
  };
};
