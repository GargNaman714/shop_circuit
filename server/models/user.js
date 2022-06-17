// this contains code for User Schema
const mongoose=require('mongoose');
const { productSchema } = require('./product');

//this will decide the structure/schema of our User Data
const userSchema = mongoose.Schema({

    // name of the user
    name: {
      required: true,
      type: String,
      trim: true, // removes leading and trailing spaces. Eg: if user typed in the name as: "   naman  ",it will trim it down to:"naman"
    },
    email: {
      required: true,
      type: String,
      trim: true,
      validate: { //validating the emailID, it should have @ sign, should also inlcude '.com' string
        validator: (value) => {

            //this is RgEx(Regular expression) to validate the email Id. Stackoverflow se uthaya hai ye regex. Ye validate kr deta hai email
          const re =
            /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

            //suppose, value='naman@gmail.com', then this function matches value with the  regex re
          return value.match(re);
        },

        //this prop will run  only when the validator is false
        message: "Please enter a valid email address",
      },
    },
    password: {
      required: true,
      type: String,  
    //   validate: { //validating password to make it atleast of 6 characters
    //     validator: (value) => {

    //         return value.lenght>3; //since here, value is of type string(coz password is of type:String), we  can us lenght function to find its size
    //     },

    //     //this prop will run  only when the validator is false
    //     message: "Passowrd too weak. Please enter a longer password",
    //   },

    },
    address: {
      type: String,
      default: "", // default is empty string
    },

    // to define the type : user/admin/seller
    type: {
      type: String,
      default: "user",
    },

    //cart is an array of products + the quantity in which the product is ordered
    cart: [
      {
        product: productSchema, // the type of the 'product' is 'productSchema' which is a schema, not a model
        quantity: {
          type: Number,
          required: true,
        },
      },
    ],
    
  });
  
  //creating model out of this schema
  const User = mongoose.model("User", userSchema); //==> (modelName,schema)

  //the User variable(defined above) can be used in this file only. In order to make it accessible to others as well --> export it
  module.exports = User;