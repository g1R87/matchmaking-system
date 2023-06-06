import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import BadRequestError from "../errors/bad-request";
import UnauthenticatedError from "../errors/unauthenticated";

import NotFoundError from "../errors/not-found";
import User, { UserInput } from "../models/user.model";
import { calculateDistance } from "../utils/distance.calc";
import { searchUserWithInterest } from "../utils/searchuser";

//recommendation filter  algorithm
export const fetchUser = async (req: Request, res: Response) => {
  const _id = res.locals.user.userID;
  const allUsers: any = await User.find({});

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
  allUsers.forEach((user: any) => {
    likedUsersPrime.forEach((id: any) => {
      if (Object.keys(user.matches).includes(id)) {
        doublePrimearray.push(user._id);
      }
    });
  });

  //used to generate leastlikey list(non including own id)
  const doublePrimearray2 = doublePrimearray.concat([_id]);

  const mostLikely: any = await User.find({
    _id: { $in: doublePrimearray },
  }).select("-password -isVerified -isUpdated -__v -refreshToken -matches");

  const leastLikely: any = await User.find({
    _id: { $nin: doublePrimearray2 },
    gender_identity: interest,
  }).select("-password -isVerified -isUpdated -__v -refreshToken -matches");

  const fetchedUsers = mostLikely.concat(leastLikely);

  res.send(fetchedUsers);
  res.send(mostLikely);
};

//searching algo
export const searchUser = async (req: Request, res: Response) => {
  const ownId = res.locals.user.userID;
  const { targetInterest } = req.body;
  const allUsers: UserInput[] = await User.find({
    _id: { $nin: [ownId] },
  }).select("-password -pfp");
  console.log(allUsers.length);
  const foundUsers = searchUserWithInterest(allUsers, targetInterest);
  res.send(foundUsers);
};

//distance filter algorithm
// export const filterByDistance = async (req: Request, res: Response) => {
//   const { lat, lon } = req.body;
//   let newArr: Array<any> = [];
//   const allUsers: Array<UserInput> = await User.find({});
//   if (allUsers) {
//     for (let i = 0; i < allUsers.length; i++) {
//       const distance = calculateDistance(
//         lat,
//         lon,
//         allUsers[i].coords[0],
//         allUsers[i].coords[1]
//       );

//       const filteredUsersList = {
//         ...allUsers[i],
//         distance,
//       };

//       if (distance <= 15) newArr.push(filteredUsersList);
//     }
//     res.status(200).send(newArr);
//   }
// };
