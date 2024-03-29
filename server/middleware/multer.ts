import multer from "multer";
import path from "path";

//set storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      file["fieldname"] + "-" + Date.now() + path.extname(file.originalname)
    );
  },
});

export const upload = multer({ storage: storage });
