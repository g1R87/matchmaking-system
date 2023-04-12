export default class CustomAPIError extends Error {
  statusCode = NaN;
  constructor(message: string) {
    super(message);
  }
}
