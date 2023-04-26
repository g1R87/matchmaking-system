import mongoose from "mongoose";

const MessageSchema = new mongoose.Schema({
  timestamp: {
    type: String,
    default: new Date().toJSON(),
  },
  from_userId: {
    type: String,
  },
  to_userId: {
    type: String,
  },
  message: {
    type: String,
  },
});

export default mongoose.model("Message", MessageSchema);
