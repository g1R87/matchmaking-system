import { UserInput } from "../models/user.model";
export const searchUserWithInterest = (
  users: UserInput[],
  targetInterest: string
) => {
  const foundUsers: UserInput[] = [];
  const threshold = 0.5;

  //iteration over each user
  for (const user of users) {
    const userInterest = user.interest;
    const targetLength = targetInterest.length;

    // calculation of similarity score
    for (const interest of userInterest) {
      let score = 0;
      let i = 0;
      let j = 0;
      while (i < interest.length && j < targetLength) {
        if (interest[i].toLowerCase() === targetInterest[j].toLowerCase()) {
          score++;
          j++;
        }
        i++;
      }

      //normalization of score
      const similarity = score / interest.length;

      //testing
      console.log("for string:", interest);
      console.log("target string:", targetInterest);
      console.log("score:", score);
      // console.log("similarity:", similarity);

      if (similarity >= threshold) {
        foundUsers.push(user);
      }
    }
  }
  return foundUsers;
};
