export const findId = (sid: string, obj: any) => {
  console.log("func id", sid);
  console.log("func obj,", obj);
  const curList = obj[sid];
  const priority: any = {};

  for (var key in obj) {
    priority[key] = [];

    if (key == sid) continue;
    curList.forEach((e: any) => {
      if (obj[key].includes(e)) {
        priority[key] = [...priority[key], e];
      }
    });
  }

  console.log(priority);

  let id = "";
  let length = 0;
  for (var key in priority) {
    let tlength = priority[key].length;
    if (tlength > length) {
      length = tlength;
      id = key;
    }
  }
  return { id, matches: id == "" ? [] : priority[id] };
};
