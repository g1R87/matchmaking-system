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
  console.log("this month is ", formData.dob_month);
  const opts = { runValidators: true };
  const updatedDocument = {
    $set: {
      first_name: formData.first_name ?? undefined,
      dob_day: formData.dob_day ?? undefined,
      dob_month: formData.dob_month ?? undefined,
      dob_year: formData.dob_year ?? undefined,
      show_gender: formData.show_gender == "1" ? true : false,
      gender_identity: formData.gender_identity ?? undefined,
      gender_interest: formData.gender_interest ?? undefined,
      url: formData.url ?? undefined,
      about: formData.about ?? undefined,
      matched: formData.matches ?? undefined,
      isUpdated: formData.isUpdated ?? undefined,
      isVerified: formData.isVerified ?? undefined,
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

//update location
export const updateLocation = async (req: Request, res: Response) => {
  const { lat, lon } = req.body;
  if (!lat || !lon) {
    throw new BadRequestError("Please provide latitide and longitude");
  }
  const _id = res.locals.user.userID;
  const updatedUser = await User.findByIdAndUpdate(
    { _id },
    {
      $set: {
        coords: [lat, lon],
      },
    }
  );
  res.status(200).send(updatedUser);
};

//! update all (to be removed)
export const updateall = async (req: Request, res: Response) => {
  const updatedUser = await User.updateMany(
    {},
    { chatList: [], coord: [27.7172, 85.324] }
  );
  res.status(200).send(updatedUser);
  // res.send(res.locals.user);
};
