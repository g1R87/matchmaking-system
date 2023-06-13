import { Request, Response } from "express";

import NotFoundError from "../errors/not-found";
import User, { UserInput } from "../models/user.model";
import {
  getBlackListedUsers,
  getNPrimeUsers,
  getNUsers,
  getNdoublePrimeUsers,
  getRecommendedUsers,
} from "../services/filter.services";
import { calculateDistance } from "../utils/distance.calc";
import { searchUserWithInterest } from "../utils/searchuser";

//recommendation filter  algorithm
export const fetchUser = async (req: Request, res: Response) => {
  const _id = res.locals.user.userID as string;

  const allUsers: UserInput[] = await User.find({});

  const user: UserInput = (await User.findById(_id)) as UserInput;
  const genderInterest = user.gender_interest;
  const chatList = user.chatList;
  const interests = user.interest;

  //users that have score below negative 3 are not fetched anymore
  const blacklistUsersIds = getBlackListedUsers(user);

  const likedUsers: UserInput[] = await getNUsers(user);

  const likedUsersPrime = getNPrimeUsers(likedUsers);

  const doublePrimearray = getNdoublePrimeUsers(
    allUsers,
    likedUsersPrime,
    chatList
  );

  //used to generate leastlikey list(non including own id, blacklist and current chatlist)
  const filteredDoublePrime = doublePrimearray
    .concat([_id])
    .concat(blacklistUsersIds)
    .concat(chatList);

  const fetchedUsers = await getRecommendedUsers(
    doublePrimearray,
    filteredDoublePrime,
    genderInterest,
    interests
  );
  res.send(fetchedUsers);
  // res.send(doublePrimearray);
};

//searching
export const searchUser = async (req: Request, res: Response) => {
  const ownId = res.locals.user.userID;
  const { targetInterest } = req.body;
  const allUsers: UserInput[] = await User.find({
    _id: { $nin: [ownId] },
  }).select("-password");
  const foundUsers = searchUserWithInterest(allUsers, targetInterest);
  console.log(foundUsers.length);
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
