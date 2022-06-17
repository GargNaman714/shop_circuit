//simillar to user model, we will now create product model to store in MongoDB
const mongoose=require('mongoose');
const ratingSchema = require('./rating');

const productSchema=mongoose.Schema({
    name:{
        type:String,
        required:true,
        trim:true, // removes leading and trailing spaces. Eg: if user typed in the name as: "   naman  ",it will trim it down to:"naman"
    },
    description:{
        type:String,
        required:true,
        trim:true,
    },
    images:[ // in this we are storing an array of urls of the images of product, so thats why this syntax for array
        { // this will define properties of each element in the 'images' array
            type:String, // coz we'll be storing urls of images of product
            required:true,
        }
    ],
    quantity:{
        type:Number,
        required:true,
    },
    price:{
        type:Number,
        required:true,
    },
    category:{
        type:String,
        required:true,
        trim:true,
    },

    //ratings   
    ratings:[ratingSchema], // array of ratingSchema coz lot of users are going to rate the product--> to unn saare ratings  ki info laane k liye using array
});

//models are created when we want to store data directly as a collection in MongoDB
//thats why we have created model for productSchema.
//But on the other hand, we didn't create model for ratingSchema in rating.js file coz we only wanted it to use as kind of value of our 'rating' property


//creating model out of this schema
const Product=mongoose.model("Product",productSchema); //==> (modelName,schema)

module.exports = { Product, productSchema };