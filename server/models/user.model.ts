import mongoose from "mongoose";
import { v4 as uuidv4 } from "uuid";
import { hashPassword } from "../utils/password";

const UserSchema = new mongoose.Schema({
  user_id: {
    type: String,
    default: uuidv4(),
  },
  first_name: {
    type: String,
    minlenght: 3,
  },
  email: {
    type: String,
    required: [true, "Email is required!"],
    match: [
      /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
      "Provide a valid email!",
    ],
    unique: true,
  },
  password: {
    type: String,
    required: [true, "Password is required!"],
    minlength: 6,
  },
  dob_day: {
    type: Number,
  },
  dob_month: { type: Number },
  dob_year: { type: Number },
  show_gender: { type: Boolean, default: false },
  gender_identity: { type: String },
  gender_interest: { type: String },
  url: { type: String },
  about: { type: String },
  matches: { type: Array<object>, default: [] },
});

//pre middleware - hashing
UserSchema.pre("save", async function () {
  this.password = await hashPassword(this.password);
});

export default mongoose.model("User", UserSchema);
