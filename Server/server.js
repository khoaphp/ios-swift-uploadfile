var express = require("express");
var app = express();
app.use(express.static("pubic"));
app.set("view engine", "ejs");
app.set("views", "./views");

app.listen(3000);

//multer
var multer  = require('multer');
var storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'public/upload')
    },
    filename: function (req, file, cb) {
      cb(null, Date.now()  + "-" + file.originalname)
    }
});  
var upload = multer({ 
    storage: storage,
    fileFilter: function (req, file, cb) {
        console.log(file);
        if(
            file.mimetype=="image/bmp" || 
            file.mimetype=="image/png" ||
            file.mimetype=="image/jpg" ||
            file.mimetype=="image/jpeg" 
        ){
            cb(null, true)
        }else{
            return cb(new Error('Only image are allowed!'))
        }
    }
}).single("avatar");

app.post("/uploadFile",  function(req, res){
    upload(req, res, function (err) {
        if (err instanceof multer.MulterError) {
            res.json({result:0, message:"A Multer error occurred when uploading."});
        } else if (err) {
            res.json({result:0, message:"An unknown error occurred when uploading."});
        }else{
            console.log(req.file);
            res.json({result:1, message:"Upload is succeed", file:req.file.filename});
        }
    });
});