export const findId = (sid: string, obj: any) => {
  console.log(obj);
  const curList = obj[sid].iList;
  const priority: any = {};
  const threshold = 0.6;

  for (var key in obj) {
    priority[key] = [];
    if (key == sid) continue;

    for (const query in curList) {
      const queryLength = query.length;
      for (const str in obj[key].iList) {
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

        const similarity = score / strLength;
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
    if (tlength > length) {
      length = tlength;
      id = key;
    } else if (tlength == length) {
      let val = Math.round(Math.random());
      if (val == 1) {
        length = tlength;
        id = key;
      }
    }
  }
  return { id, matches: id == "" ? [] : priority[id] };
};
