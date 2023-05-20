import mongoose from "mongoose";

const MessageSchema = new mongoose.Schema(
  {
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
      required: true,
    },
  },
  { timestamps: true }
);

export default mongoose.model("Message", MessageSchema);
