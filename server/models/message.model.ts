import mongoose from "mongoose";

const MessageSchema = new mongoose.Schema({
  timestamp: {
    type: String,
    default: new Date().toJSON(),
  },
  from_userId: {
    type: mongoose.Types.ObjectId,
    ref: "User", // reference user model
    required: [true, "Please provide the user"],
  },
  to_userId: {
    type: mongoose.Types.ObjectId,
    ref: "User",
    required: [true, "Please provide destination user"],
  },
  message: {
    type: String,
  },
});

export default mongoose.model("Message", MessageSchema);
