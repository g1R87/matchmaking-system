import Fuse from "fuse.js";
import { UserInput } from "../models/user.model";
export const searchUserWithInterest = (
  users: Array<UserInput>,
  targetInterest: string
) => {
  const matchingUsers: UserInput[] = [];
  // const queue = [];

  const options: Fuse.IFuseOptions<UserInput> = {
    includeScore: true,
    minMatchCharLength: 3,
    findAllMatches: true,
    keys: ["interest"],
  };

  // for (const user of users) {
  //   queue.push(user);
  // }

  // while (queue.length > 0) {
  //   const currentUser: UserInput | undefined = queue.shift();
  //   if (currentUser) {
  //     console.log(currentUser.interest);
  //     if (currentUser.interest.includes(targetInterest)) {
  //       matchingUsers.push(currentUser);
  //     }
  //   }
  // }

  const fuse = new Fuse(users, options);

  const searchResult = fuse.search(targetInterest);

  for (const result of searchResult) {
    matchingUsers.push(result.item);
  }
  return matchingUsers;
};
