// const sid = "4";
// const obj: any = {
//   1: ["apple", "banana"],
//   2: ["mango", "orange"],
//   3: ["apple"],
//   4: ["banana", "melon", "apple"],
// };

// const testObj = {
//   1: [],
// };

// const curlist = obj["4"];
// // testObj["1"] = [...testObj["1"], "syau"];
// // let id = "";
// // let length = 0;
// // for (var key in obj) {
// //   let tlength = obj[key].length;
// //   if (tlength > length) {
// //     length = tlength;
// //     id = key;
// //   }
// // }
// // console.log(id);

// // for (var key in obj) {
// //   if (key == sid) continue;
// //   curlist.forEach((e) => {
// //     if (obj[key].includes(e)) {
// //       console.log({ key, match: e });
// //     }
// //   });
// // }

// // const findId = () => {
// //   const priority: any = {};
// //   for (var key in obj) {
// //     priority[key] = [];

// //     if (key == sid) continue;
// //     curlist.forEach((e: any) => {
// //       if (obj[key].includes(e)) {
// //         priority[key] = [...priority[key], e];
// //       }
// //     });
// //   }
// //   console.log(priority);
// //   let id = "";
// //   let length = 0;
// //   for (var key in priority) {
// //     let tlength = priority[key].length;
// //     if (tlength > length) {
// //       length = tlength;
// //       id = key;
// //     }
// //   }
// //   return { id, matches: priority[id] };
// // };

// export const findId = (oid: string, o: any) => {
//   const priority: any = {};
//   for (var key in o) {
//     priority[key] = [];

//     if (key == oid) continue;
//     curlist.forEach((e: any) => {
//       if (o[key].includes(e)) {
//         priority[key] = [...priority[key], e];
//       }
//     });
//   }
//   console.log(priority);
//   let id = "";
//   let length = 0;
//   for (var key in priority) {
//     let tlength = priority[key].length;
//     if (tlength > length) {
//       length = tlength;
//       id = key;
//     }
//   }
//   return { id, matches: priority[id] };
// };

// const a = findId(sid, );
// console.log("best id is", a);
