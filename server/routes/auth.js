const express = require('express');
const User = require('../models/user');
const bcryptjs = require('bcryptjs');
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");

//ye isliye bana rhe hai kyuki agr hme bahut saari get request call krni ho, to saari index.js mein hi call krdenge to achha nhi lagega. Isliye alag se kaam kr rhe routes bana ke
const authRouter = express.Router(); // ye isliye use krte hai taaki express ko dobra initialise na krna pade as we diid in index.js[const app= express();]

//just for practice how to create get api/testing:

// authRouter.get("/user",(req,res)=>{
//     res.json({msg:"naman"});
// });

//SIGNUP ROUTE
//creating authentication for loging-in and sign-up
//we will be creating "post" api since we need to send data to Database
//creating authentication for loging-in and sign-up
//we will be creating "post" api since we need to send data to Database
authRouter.post("/api/signup", async (req, res) => {
  try {

    //WE NEED TO DO THE FOLLOWING THINGS:
    //get data from clent(frontend-->flutter): using req.body
    //post data into Databse
    //return data to the user

    // req.body return a map/ object. Eg: {'name':name, 'email':email, 'password':password}
    const { name, email, password } = req.body;

    //     //in case of firebase,it handles all the validations by itself, like: if password is less than 6 chars: it shows weak-pasword, also it doesnt allow multiple signups with same emails etc.
    //     //but in MongoDB, we have to do manually

    //     //findOne() is provided by mongoose.
    const existingUser = await User.findOne({ email });

    //since findOne is a promise, we need to mark our function as async coz first it goes to the  Database and then searches for same value, therefore we need to await.

    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

    //hashing the password
    const hashedPassword = await bcryptjs.hash(password, 8);

    //since this value would be changing, therefore dont make it const
    let user = new User({
      email,
      password: hashedPassword,
      name,
    });
    user = await user.save(); //saving data into MongoDB
    res.json(user); //sending to client side
  } catch (e) {
    res.status(500).json({ error: e.message }); //500 status code is for internal server error
  }
});



 //Sign In Route
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) { // if email entered is not correct
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }
    // console.log(password);
    // console.log(user.password);
    const isMatch = await bcryptjs.compare(password, user.password); //returns a boolean value
    if (!isMatch) {
      // console.log('incorrect');
      return res.status(400).json({ msg: "Incorrect password." });
    }
    // console.log('correct');

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
    //the above statement will post the request in json format as:
    // {
    //  'token':'tokensomething',
    // 'name':'naman'
    // 'email':"naman@gmail.com"
    // }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }  
});


//api to validate token
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token"); 

    //if token is null which means the user is using our app for the very first time
    if (!token) return res.json(false);

    //if token is non-null, verify it with jwt if it is valid or not
    const verified = jwt.verify(token, "passwordKey");

    //if token is not verified--> return false(in Json format)
    if (!verified) return res.json(false);

    //if token is verified, find if there is any user with this token
    const user = await User.findById(verified.id);

    //if there is no such user with this token--> return false(in Json format)
    if (!user) return res.json(false);

    //after all the validation, return true
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

/*
What is difference between GET and POST method in API?
GET is used for viewing something, without changing it, while POST is used for changing something. For example, a search page should use GET to get data while a form that changes your password should use POST . Essentially GET is used to retrieve remote data, and POST is used to insert/update remote data.
*/

//get user data api
  authRouter.get("/", auth, async (req, res) => { //'auth'--> is a middleware which will make sure that u r authorized, that means u only have the capability to access this route if you are signed in
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});


//the authRouter variable can be used in this file only. In order to make it accessible to others as well --> export it
// we should make sure that our route is connected to index.js
module.exports = authRouter; // now this authRouter variable is available outside this file as well

//agar multiple variables export krne ho to, then we export objects
// EG: module.exports={authRouter,name:"naman"}; //authRouter:authRouter likhte tabhi bhi chalta, it is just short-hand when the key and value have same name




