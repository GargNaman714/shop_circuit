const mongoose=require("mongoose");

const ratingSchema=mongoose.Schema({

    //userID of the user who has rated the project
    userId:{
        type:String,
        required:true,
    },
    rating:{
        type:Number,
        required:true,
    }
});

//models are created when we want to store data directly as a collection in MongoDB
//thats why we have created model for productSchema.
//But on the other hand, we didn't create model for ratingSchema in rating.js file coz we only wanted it to use as kind of value of our 'rating' property


module.exports=ratingSchema;