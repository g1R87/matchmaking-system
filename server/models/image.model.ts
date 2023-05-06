import mongoose from "mongoose";

export interface ImageInput extends mongoose.Document {}

const ImageSchema = new mongoose.Schema({
  filename: {
    type: String,
    required: [true, "Provide a filename"],
    unique: [true, "Already Exists"],
  },
  contentType: {
    type: String,
    required: [true, "Provide content type"],
  },
  image: {
    type: String,
    required: [true, "Provide image properties"],
  },
  uploader: {
    type: mongoose.Types.ObjectId,
    ref: "User",
    required: [true, "Uploader required"],
  },
});

export default mongoose.model<ImageInput>("Image", ImageSchema);
