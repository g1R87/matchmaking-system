import jwt from "jsonwebtoken";
import mongoose from "mongoose";
import { v4 as uuidv4 } from "uuid";
import { hashPassword, verifyPassword } from "../utils/password";

interface matchType {
  [key: string]: number;
}

export interface UserInput extends mongoose.Document {
  user_id: string;
  first_name: string;
  email: string;
  password: string;
  dob_day: number;
  dob_month: number;
  dob_year: number;
  show_gender: boolean;
  gender_identity: string;
  gender_interest: string;
  interest: string[];
  url1: string;
  url2: string;
  url3: string;
  about: string;
  isVerified: Boolean;
  isUpdated: Boolean;
  matches: matchType;
  chatList: string[];
  pending: string[];
  coords: number[];
  key: string;
  refreshToken: string;
  pfp: { data: string; contentType: string };

  createJWT(): string;
  createRJWT(): string;
  checkPassword(password: string): boolean;
}

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
  gender_identity: {
    type: String,
    enum: {
      values: ["male", "female", "others"],
      message: "{VALUE} is not supported! ",
    },
  },
  gender_interest: { type: String },
  interest: {
    type: Array,
    default: [],
  },
  pfp: {
    data: String,
    contentType: String,
  },
  url1: { type: String },
  url2: { type: String },
  url3: { type: String },
  about: { type: String },
  matches: { type: Object, default: {} },
  isVerified: {
    type: Boolean,
    default: false,
  },
  isUpdated: {
    type: Boolean,
    default: false,
  },
  chatList: {
    type: Array,
    default: [],
  },
  pending: {
    type: Array,
    default: [],
  },
  coord: {
    type: Array,
    default: [27.7172, 85.324],
  },
  key: { type: String },
  refreshToken: String,
});

//pre middleware - hashing
UserSchema.pre("save", async function () {
  this.password = await hashPassword(this.password);
});

//instance methods

//access token
UserSchema.methods.createJWT = function (this: UserInput) {
  return jwt.sign(
    { userID: this._id, email: this.email },
    process.env.JWT_SECRET as string,
    {
      expiresIn: process.env.JWT_LIFETIME,
    }
  );
};

//refresh token
UserSchema.methods.createRJWT = function (this: UserInput) {
  return jwt.sign(
    { userID: this._id, email: this.email },
    process.env.RJWT_SECRET as string,
    {
      expiresIn: process.env.RJWT_LIFETIME,
    }
  );
};

UserSchema.methods.checkPassword = async function (
  password: string
): Promise<boolean> {
  return await verifyPassword(password, this.password);
};

export default mongoose.model<UserInput>("User", UserSchema);
