import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import BadRequestError from "../errors/bad-request";
import UnauthenticatedError from "../errors/unauthenticated";

import User from "../models/user.model";

interface reqbody {
  email: String;
  password: String;
  confirmPassword: String;
}

//regiser / signup action / Create
export const signup = async (req: Request, res: Response) => {
  console.log(req.body);
  const { email, password, confirmPassword } = req.body;

  if (!email || !password || !confirmPassword) {
    throw new BadRequestError("Email/Password is required");
  }

  if (password != confirmPassword) {
    throw new BadRequestError("Passwords dont match");
  }

  const user = await User.create({ email, password });
  const token = user.createJWT();
  res.status(StatusCodes.CREATED).send({ userId: user.user_id, token });
};

//update action
export const updateUser = async (req: Request, res: Response) => {
  //send formData object in req.body in action application eg React
  const formData = req.body;
  // console.log("data from form: ", formData);
  // console.log(res.locals.user);

  //use cookies in actual application for userID
  console.log(formData);
  const opts = { runValidators: true };
  const updatedDocument = {
    $set: {
      first_name: formData.first_name,
      dob_day: formData.dob_day,
      dob_month: formData.dob_month,
      dob_year: formData.dob_year,
      show_gender: formData.show_gender == "1" ? true : false,
      gender_identity: formData.gender_identity,
      gender_interest: formData.gender_interest,
      url: formData.url,
      about: formData.about,
      matched: formData.matches,
      isUpdated: formData.isUpdated,
      isVerified: formData.isVerified,
    },
  };
  const updatedUser = await User.updateOne(
    { _id: res.locals.user.userID },
    updatedDocument,
    opts
  );
  res.status(200).send(updatedUser);
  // res.send(res.locals.user);
};

//get one
export const getUser = async (req: Request, res: Response) => {
  //send from front end as params
  const userID = req.query.id;
  if (!userID) {
    throw new BadRequestError("Please provide id");
  }
  console.log(req.query);
  const user = await User.findById(userID);
  res.status(200).json(user);
};

//matched users
export const matchUser = async (req: Request, res: Response) => {
  const { userId, matchedUserId } = req.body;
  const query = { _id: userId };
  const updateDocument = {
    $push: { matches: { _id: matchedUserId } },
  };

  const matchUser = await User.updateOne(query, updateDocument);
  res.send(matchUser);
};

//get all
export const getAllUsers = async (req: Request, res: Response) => {
  const users = await User.find({}).select(["-pfp"]);
  // const users = await User.find({
  //   _id: {
  //     $in: [
  //       "63e4f6abb9393e67e9418bc6",
  //       "643651e04b010392dc68cda4",
  //       "63e4f6abb9393e67e9418bc6",
  //       "643651e04b010392dc68cda4",
  //       "64368fc6d51b4ed48b04a587",
  //     ],
  //   },
  // }).select(["-pfp"]);
  res.status(StatusCodes.OK).send(users);
};

//get all (filtered by gender)
export const getUsers = async (req: Request, res: Response) => {
  const gender = req.query.gender;
  console.log(gender);
  const query = { gender_identity: gender };
  const users = await User.find(query);
  res.status(StatusCodes.OK).send(users);
};

//update all
export const updateall = async (req: Request, res: Response) => {
  const updatedUser = await User.updateMany({}, { matches: {} });
  res.status(200).send(updatedUser);
  // res.send(res.locals.user);
};

//vote user
export const voteUserUp = async (req: Request, res: Response) => {
  console.log("voteup");
  const id = req.query.id as string;
  if (!id) {
    throw new BadRequestError("Please provide id");
  }
  const user: any = await User.findById({ _id: res.locals.user.userID });
  user.matches[id] = user.matches[id] ? user.matches[id] + 1 : 1;
  const updatedMatch = user.matches;
  const updateduser = await User.updateOne(
    { _id: res.locals.user.userID },
    { matches: updatedMatch }
  );

  res.status(200).send(updateduser);
};
export const voteUserDown = async (req: Request, res: Response) => {
  console.log("votedown");
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

//recommendation algorithm
export const fetchUser = async (req: Request, res: Response) => {
  const _id = res.locals.user.userID;
  const user: any = await User.findById(_id);
  const interest = user.gender_interest;
  const likedUserIds = Object.keys(user.matches).filter(
    (id) => user.matches[id] > 0
  );
  const likedUsers: any = await User.find({
    _id: { $in: likedUserIds },
  });
  const likedUsersPrime = likedUsers.reduce((acc: any, cur: any) => {
    if (!cur.matches) {
      return acc;
    }
    const likedUsersIds_: any = Object.keys(cur.matches).filter(
      (id) => cur.matches[id] > 0
    );
    return [].concat(likedUsersIds_, acc);
  }, []);

  const doublePrimearray: any = [];
  const all: any = await User.find({});
  all.forEach((user: any) => {
    likedUsersPrime.forEach((id: any) => {
      if (Object.keys(user.matches).includes(id)) {
        doublePrimearray.push(user._id);
      }
    });
  });

  const mostLikely: any = await User.find({
    _id: { $in: doublePrimearray },
  }).select("-pfp-password");

  const leastLikely: any = await User.find({
    _id: { $nin: doublePrimearray },
    gender_identity: interest,
  }).select("-pfp-password");

  const fetchedUsers = mostLikely.concat(leastLikely);

  // const all: any = await User.find({});
  // const fetchedUsers = all.filter((u: any) => {
  //   if (!u.matches) {
  //     return false;
  //   } else {
  //     const found = likedUsersPrime.reduce((acc: any, cur: any) => {
  //       if (acc) {
  //         return true;
  //       } else {
  //         if (u.matches[cur] && u.matches[cur] > 0) {
  //           return true;
  //         } else {
  //           return false;
  //         }
  //       }
  //     }, false);
  //     return found;
  //   }
  // });

  res.send(fetchedUsers);
};
