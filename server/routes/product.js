// it will fetch us all the products belonging to a certain category

const express=require("express");
const productRouter=express.Router();
const auth=require("../middlewares/auth"); // since we need 'auth' middleware
const { Product } = require("../models/product");

productRouter.get("/api/products/",auth,async(req,res)=>{
    try {
        console.log(req.query.category);
        const products = await Product.find({ category: req.query.category });
        res.json(products);
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
});


//api/products?category=Essentials--> acceses 'Essentials' using --> req.query.category
//api/amazon?theme=dark
//api/products:category=Essentials --> acceses 'Essentials' using --> req.params.category
//Now lets create a get request to search products and get them
// /api/products/search/i

productRouter.get("/api/products/search/:name", auth, async (req, res) => {
    try {
      // req.params.name is same as req.params
      const products = await Product.find({
        name: { $regex: req.params.name, $options: "i" }, //agr 'i' bhi search karenge to ye simillar options dikha dega . Eg: iPhone
      });
  
      res.json(products);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  //create a post request route/API to rate the product
  productRouter.post("/api/rate-product", auth, async (req, res) => {
    try {
      const { id, rating } = req.body; //extract the product ID and rating from the user
      let product = await Product.findById(id); // find the product which has been rated by the user using product id
  
      for (let i = 0; i < product.ratings.length; i++) {
        if (product.ratings[i].userId == req.user) { //we are able to access the userID of the user who has just now rated the product using--> req.user because of the 'auth' middleware
          product.ratings.splice(i, 1); //deleting the previous rating which the current user had given some time back so that a single user is not able to rate the same product multiple times
          break;
        }
      }
  
      const ratingSchema = {
        userId: req.user,
        rating,
      };
  
      product.ratings.push(ratingSchema);
      product = await product.save();
      res.json(product);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  
  //api to fetch deal of the day. The product with the highest rating will be the deal of the day
  productRouter.get("/api/deal-of-day", auth, async (req, res) => {
    try {
      let products = await Product.find({}); //fetch all the products
  
      //sort the list of product in decreasing order of their ratings, i.e. the product with highest rating is at starting position in the array after sorting
      products = products.sort((product1, product2) => {
        let product1Sum = 0;
        let product2Sum = 0;
  
        for (let i = 0; i < product1.ratings.length; i++) {
          product1Sum += product1.ratings[i].rating;
        }
  
        for (let i = 0; i < product2.ratings.length; i++) {
          product2Sum += product2.ratings[i].rating;
        }
        return product1Sum < product2Sum ? 1 : -1;
      });
  
      res.json(products[0]); //return deal of the day product(product with highest rating) to the client
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

module.exports = productRouter;