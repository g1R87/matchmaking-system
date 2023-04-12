import BadRequestError from "./bad-request";
import CustomAPIError from "./custom-api";
import NotFoundError from "./not-found";
import UnauthenticatedError from "./unauthenticated";

export const errors = {
  CustomAPIError,
  UnauthenticatedError,
  NotFoundError,
  BadRequestError,
};
