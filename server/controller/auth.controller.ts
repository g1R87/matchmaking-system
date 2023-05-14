import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import jwt from "jsonwebtoken";
import BadRequestError from "../errors/bad-request";
import ForbiddenError from "../errors/forbidden";
import UnauthenticatedError from "../errors/unauthenticated";
import User from "../models/user.model";

interface jwtPayload {
  userId: string;
  name: string;
}

//login action
export const login = async (req: Request, res: Response) => {
  // console.log(req.body);
  const { email, password } = req.body;

  if (!email || !password) {
    throw new BadRequestError("Email/Password is required");
  }

  const user = await User.findOne({ email });

  if (!user) {
    throw new UnauthenticatedError("Invalid credentials / User doesnt exist");
  }

  const isPasswordCorrect = await user.checkPassword(password);
  if (!isPasswordCorrect) {
    throw new UnauthenticatedError("invalid credentials");
  }

  const token = user.createJWT();
  const tokenrefresh = user.createRJWT();
  await User.findOneAndUpdate({ email }, { refreshToken: tokenrefresh });
  // console.log(user);
  res.cookie("jwt", tokenrefresh, {
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000,
  });
  res.status(StatusCodes.OK).json({
    userId: user._id,
    isVerified: user.isVerified,
    isUpdated: user.isUpdated,
    token,
    tokenrefresh,
  });
};

//refresh controller
export const handleRefreshToken = async (req: Request, res: Response) => {
  // const cookies = req.cookies;

  // if (!cookies?.jwt) {
  //   throw new UnauthenticatedError("where kuki");
  // }

  // const refreshToken = cookies.jwt;

  // console.log("the token refresh is: ", cookies.jwt);

  const refreshToken = req.body.tokenrefresh;

  console.log("the cookies is: ", refreshToken);
  if (!refreshToken) {
    throw new ForbiddenError("Forbidden");
  }
  const user = await User.findOne({ refreshToken });

  if (!user) {
    throw new ForbiddenError("Forbidden");
  }

  //eval jwt
  jwt.verify(
    refreshToken,
    process.env.RJWT_SECRET as string,
    (err: any, decoded: any) => {
      if (err || decoded.email !== user.email) {
        throw new ForbiddenError("Forbidden");
      }
      const token = user.createJWT();
      res.status(StatusCodes.OK).json({
        userId: user._id,
        isVerified: user.isVerified,
        isUpdated: user.isUpdated,
        token,
      });
    }
  );
};

export const logout = async (req: Request, res: Response) => {
  //clear local storage on client
  const refreshToken = req.body.tokenrefresh;

  console.log("the cookies is: ", refreshToken);
  if (!refreshToken) {
    res.status(204).send({ msg: "No content" });
  }

  //check db and update
  const user = await User.findOneAndUpdate(
    { refreshToken },
    { refreshToken: "" }
  );
  if (!user) {
    // res.clearCookie("jwt", { httpOnly: true, maxAge: 24 * 60 * 60 * 1000 });
    res.status(204).send({ msg: "no content" });
  }

  //delete in db  && clear cookie
  // res.clearCookie("jwt", { httpOnly: true, maxAge: 24 * 60 * 60 * 1000 });
  res.status(204).send("logout");
};
