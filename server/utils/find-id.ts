export const findId = (sid: string, obj: any) => {
  console.log(obj);
  const curList = obj[sid].iList;
  console.log("current user's list", curList);
  const priority: any = {};
  const threshold = 0.6;

  for (var key in obj) {
    if (key == sid) continue;
    priority[key] = [];

    for (const query of curList) {
      console.log("query", query);
      const queryLength = query.length;
      for (const str of obj[key].iList) {
        let score = 0;
        const strLength = str.length;

        let i = 0;
        let j = 0;
        while (i < strLength && j < queryLength) {
          if (str[i].toLowerCase() === query[j].toLowerCase()) {
            score++;
            j++;
          }
          i++;
        }
        console.log("for word:", str);
        console.log("query:", query);
        console.log("score:", score);
        const similarity = score / strLength;
        console.log("similarity:", similarity);
        console.log("priority obj", priority);
        if (similarity >= threshold) {
          priority[key] = [...priority[key], query];
        }
      }
    }

    // curList.forEach((e: any) => {
    //   if (obj[key].iList.includes(e)) {
    //     priority[key] = [...priority[key], e];
    //   }
    // });
  }

  let id = "";
  let length = 0;
  for (var key in priority) {
    let tlength = priority[key].length;
    if (tlength == 0) continue;
    if (tlength > length) {
      length = tlength;
      id = key;
    } else if (tlength == length) {
      if (Math.round(Math.random())) {
        length = tlength;
        id = key;
      }
    }
  }
  return { id, matches: id == "" ? [] : priority[id] };
};
