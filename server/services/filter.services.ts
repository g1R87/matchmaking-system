import User, { UserInput } from "../models/user.model";

export const getBlackListedUsers = (user: UserInput) => {
  return Object.keys(user.matches).filter((id) => {
    return user.matches[id] < -3;
  });
};

export const getNUsers = async (user: UserInput) => {
  const chatList = user.chatList;
  let likedUserIds = Object.keys(user.matches).filter(
    (id) => user.matches[id] > 0
  );
  //add chatlist to N
  likedUserIds = [...new Set([...likedUserIds, ...chatList])];
  return await User.find({ _id: { $in: likedUserIds } });
};

export const getNPrimeUsers = (likedUsers: UserInput[]) => {
  return likedUsers.reduce((acc: any, cur: UserInput) => {
    if (!cur.matches) {
      return acc;
    }
    const likedUsersIds_: any = Object.keys(cur.matches).filter(
      (id) => cur.matches[id] > 0
    );
    return [].concat(likedUsersIds_, acc);
  }, []);
};

export const getNdoublePrimeUsers = (
  allUsers: UserInput[],
  likedUsersPrime: any,
  chatList: string[]
) => {
  let doublePrimearray: string[] = [];
  allUsers.forEach((user: any) => {
    likedUsersPrime.forEach((id: any) => {
      // if (Object.keys(user.matches).includes(id) && user.matches[id] > 0) {
      if (user.matches[id] > 0) {
        doublePrimearray.push(user._id);
      }
    });
  });

  //splice user whose reqs already accepted
  doublePrimearray = doublePrimearray.filter((x: any) => !chatList.includes(x));
  return doublePrimearray;
};

export const getRecommendedUsers = async (
  doublePrimearray: string[],
  filteredDoublePrime: string[],
  genderInterest: string,
  interests: string[]
) => {
  //todo: remove -pfp

  const mostLikely: UserInput[] = await User.find({
    _id: { $in: doublePrimearray },
  }).select(
    "-password -isVerified -isUpdated -__v -refreshToken -matches -pfp"
  );
  const sortedMostLikely = sortRecommendation(mostLikely, interests);

  const leastLikely: UserInput[] = await User.find({
    _id: { $nin: filteredDoublePrime },
    gender_identity: genderInterest,
  }).select(
    "-password -isVerified -isUpdated -__v -refreshToken -matches -pfp"
  );
  const sortedLeastLikely = sortRecommendation(leastLikely, interests);

  return sortedMostLikely.concat(sortedLeastLikely);
};

export const sortRecommendation = (users: UserInput[], interests: string[]) => {
  const recommendations: any = {};
  users.forEach((user: UserInput) => {
    const sharedInterests = user.interest.filter((interest) => {
      return interests.includes(interest);
    });
    const similarityScore = sharedInterests.length;

    recommendations[user._id] = similarityScore;
  });

  const sortedRecommendation = Object.entries(recommendations).sort(
    (a: any, b: any) => b[1] - a[1]
  );
  const recommendedUserIds = sortedRecommendation.map((entry) => {
    return entry[0];
  });

  const sortedUsers: UserInput[] = [];

  for (const id of recommendedUserIds) {
    for (const user of users) {
      if (user._id == id) {
        sortedUsers.push(user);
        continue;
      }
    }
  }

  return sortedUsers;
};
