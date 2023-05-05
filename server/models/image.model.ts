import mongoose from "mongoose";

const ImageSchema = new mongoose.Schema({
  filename: {
    type: String,
    required: [true, "Provide a filename"],
  },
  imgae: {
    data: Buffer,
    contentType: String,
  },
  uploader: {
    type: mongoose.Types.ObjectId,
    ref: "User",
    required: [true, "Uploader required"],
  },
});

export default mongoose.model("Image", ImageSchema);
