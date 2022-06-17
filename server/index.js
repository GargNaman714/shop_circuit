console.log('Hello! world');

//IMPORTS FROM PACKAGES
const express = require('express'); // const abc= require('express'); aise bhi likh sakte(name change kiya hai bs, ab 'abc' se saare cheeze access hogi express ki)
const { default: mongoose } = require('mongoose');
const moongose=require('mongoose'); // to make connection with the database
const adminRouter = require('./routes/admin');

//IMPORTS FROM OTHER FILES
const authRouter=require("./routes/auth"); // this is called relative importing. Jaha pr abhi khud ho usske liye write--> ./ - aur ab jaha jaana hai uska path specify krdo
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');

//INITIALIZATION. Ye initialization, middleware use krne se pehle hi likhna hai --> warna "ERROR!!"
const app= express(); //initialising express and storing it in 'app' variable
const port = process.env.PORT || 3000;
const DB="mongodb+srv://<user_name>:<password>@<cluster_name>.4jsxc.mongodb.net/?retryWrites=true&w=majority";

//middleware
//from client side(here, flutter) we r going to send  data to Server side, which in turn returns some data
//CLIENT(FLUTTER) --> middleware--> SERVER --> CLIENT(FLUTTER). 
//middleware helps in manipulating the form in which the data is sent form client to server
app.use(
  express.urlencoded({ extended: true })
);
app.use(express.json()); //post api m dikkat aa rhi thi test krte waqt isliye ye add krna pada. Destructuring (done in auth.js) iski wajah se error aa rha tha as destructuring can be used only on objects.
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);


//CONNECCTIONS
mongoose.connect(DB).then(()=>{
  console.log('Connection Successful!!');
}).catch((e)=>{
    console.log(e);
});

//CREATING AN API
//APIs have GET request,PUT request, POST request, DELETE request, UPDATE request --> CRUD(Create, Read, Update, Delete)
//creating get api
// app.get("/hello-world",(req,res)=>{  //(request, result)
//     // res.send("hello WORLD"); //sends result in text format
//     res.send({hi:"hello WORLD"}); //sends result in JSON format
// });

// app.get("/",(req,res)=>{
//     // res.send("naman GARG");
//     res.json({name: "naman GARG"});
// });

app.listen(port, "0.0.0.0", () => {
    console.log(`Server started and running on port ${port}`);
});